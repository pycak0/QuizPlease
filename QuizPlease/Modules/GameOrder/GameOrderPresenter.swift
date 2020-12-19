//
//  GameOrderPresenter.swift
//  QuizPlease
//
//  Created by Владислав on 13.08.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import Foundation
import YandexCheckoutPayments
import YandexCheckoutPaymentsApi

//MARK:- Presenter Protocol
protocol GameOrderPresenterProtocol {
    var game: GameInfo! { get set }
    var registerForm: RegisterForm { get set }
    
    var router: GameOrderRouterProtocol! { get }
    init(view: GameOrderViewProtocol, interactor: GameOrderInteractorProtocol, router: GameOrderRouterProtocol)
    
    func configureViews()
    
    func didPressSubmitButton()
    
    func sumToPay(forPeople number: Int) -> Int
    
    func priceTextColor() -> UIColor?
    
    func checkCertificate()
}

class GameOrderPresenter: GameOrderPresenterProtocol {
    weak var view: GameOrderViewProtocol?
    var interactor: GameOrderInteractorProtocol!
    var router: GameOrderRouterProtocol!
    
    var registerForm = RegisterForm()
    var game: GameInfo! {
        didSet {
            registerForm.gameId = game.id
            registerForm.paymentType = game.availablePaymentTypes.contains(.online) ? .online : .cash
        }
    }
    
    private var discountType: DiscountType = .none
    private var tokenizationModule: TokenizationModuleInput?

    required init(view: GameOrderViewProtocol, interactor: GameOrderInteractorProtocol, router: GameOrderRouterProtocol) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
    
    func configureViews() {
        view?.configureTableView()
    }
    
    func sumToPay(forPeople number: Int) -> Int {
        registerForm.countPaidOnline = number
        var price = game.priceNumber ?? 0
        var payNumber = number
        
        switch discountType {
        case .allTeamFree:
            return 0
        case let .numberOfPeopleForFree(num):
            payNumber = num
        case .none:
            break
        }
        
        if !game.isOnlineGame {
            price *= payNumber
        }
        
        return price
    }
    
    func priceTextColor() -> UIColor? {
        switch discountType {
        case .allTeamFree, .numberOfPeopleForFree(_):
            return .lightGreen
        case .none:
            return nil
        }
    }
    
    //MARK:- Check Certificate
    func checkCertificate() {
        guard let cert = registerForm.certificates else { return }
        view?.enableLoading()
        interactor.checkCertificate(forGameId: game.id, certificate: cert) { [weak self] (result) in
            guard let self = self else { return }
            self.view?.disableLoading()
            switch result {
            case let .failure(error):
                print(error)
                self.view?.showErrorConnectingToServerAlert()
            case let .success(response):
                self.discountType = response.discountType
                self.view?.showSimpleAlert(title: "Проверка сертификата", message: response.message ?? "Не удалось получить статус проверки")
                if let number = self.registerForm.countPaidOnline {
                    self.view?.setPrice(self.sumToPay(forPeople: number))
                }
            }
        }
    }
        
    //MARK:- Submit Button Action
    func didPressSubmitButton() {
        view?.view.endEditing(true)
        guard registerForm.isValid else {
            if registerForm.email.isEmpty {
                view?.showSimpleAlert(title: "Заполнены не все необходимые поля",
                                      message: "Пожалуйста, заполните все поля, отмеченные звездочкой, и проверьте их корректность")
            } else if !registerForm.email.isValidEmail {
                view?.showSimpleAlert(title: "Некорректный e-mail",
                                      message: "Пожалуйста, введите корректный адрес и попробуйте еще раз")
                { (okAction) in
                    self.view?.editEmail()
                }
                
            } else if !registerForm.phone.isValidMobilePhone {
                view?.showSimpleAlert(title: "Некорректный номер телефона",
                                      message: "Пожалуйста, введите корректный номер и попробуйте еще раз")
                { (okAction) in
                    self.view?.editPhone()
                }
            }
            
            return
        }
        
        let count = registerForm.countPaidOnline ?? 0
        let paymentSum = Double(sumToPay(forPeople: count))
        if registerForm.paymentType == .online && paymentSum > 0 {
            router.showPaymentView(
                provider: YooMoneyPaymentProvider(),
                withSum: paymentSum,
                description: createPaymentDescription(),
                delegate: self)
            
        } else {
            register()
        }

    }
    
    //MARK:- Register
    private func register() {
        view?.enableLoading()
        interactor.register(with: registerForm) { [weak self] (registerResponse) in
            guard let self = self else { return }
            self.view?.disableLoading()
            guard let response = registerResponse else {
                self.view?.showErrorConnectingToServerAlert()
                return
            }

            let title = "Запись на игру"
            var message: String = "Произошла ошибка при записи на игру"
            
            if response.shouldRedirect {
                if let url = response.link /*, let view = self.view*/ {
//                    self.interactor.confirmPayment(redirectLink: url, presentationView: view) { (error) in
//                        if let error = error {
//                            print(error)
//                            self.view?.showSimpleAlert(title: title, message: message)
//                            return
//                        }
//                    }
                    self.tokenizationModule?.start3dsProcess(requestUrl: url.absoluteString)
                } else {
                    self.view?.showSimpleAlert(title: title, message: message)
                    return
                }
            }
            else if response.paymentStatus == .succeeded {
                self.view?.dismiss(animated: true) {
                    self.completeOrder()
                }
                return
            }
            else {
                self.view?.dismiss(animated: true)
            }
            
            if response.isSuccess {
                message = response.successMsg ?? "Успешно"
            } else {
                message = response.successMsg ?? response.errorMsg ?? "Произошла ошибка при записи на игру"
            }

            self.view?.showSimpleAlert(title: title, message: message) { okAction in
                if response.isSuccessfullyRegistered {
                    self.completeOrder()
                }
            }

        }
    }
    
    private func completeOrder() {
        router.showCompletionScreen(with: game, numberOfPeopleInTeam: registerForm.count)
    }
    
    //MARK:- Create Payment Description
    private func createPaymentDescription() -> String {
        let name = game.fullTitle.trimmingCharacters(in: .whitespaces)
        return "Игра \"\(name)\": \(game.blockData), \(game.priceDetails)"
    }
    
}

//MARK:- TokenizationModuleOutput
extension GameOrderPresenter: TokenizationModuleOutput {
    func didFinish(on module: TokenizationModuleInput, with error: YandexCheckoutPaymentsError?) {
        DispatchQueue.main.async {
            self.view?.dismiss(animated: true)
        }
        
        
        print("Error:", error as Any)
    }
    
    func didSuccessfullyPassedCardSec(on module: TokenizationModuleInput) {
        DispatchQueue.main.async {
            self.view?.dismiss(animated: true) {
                self.completeOrder()
            }
        }
        print("3-D Secure process successfully passed")
    }
    
    func tokenizationModule(_ module: TokenizationModuleInput, didTokenize token: Tokens, paymentMethodType: PaymentMethodType) {
        DispatchQueue.main.async {
            //self.view?.dismiss(animated: true)
            self.tokenizationModule = module
            
            self.registerForm.paymentToken = token.paymentToken
            self.register()
            
//            self.view?.showTwoOptionsAlert(
//                title: "Токен для оплаты сгенерирован",
//                message: token.paymentToken,
//                option1Title: "OK", handler1: nil,
//                option2Title: "Скопировать") { (copyAction) in
//                    UIPasteboard.general.string = token.paymentToken
//            }
            
//            interactor.pay(with: token.paymentToken) { [weak self] (error) in
//                guard let self = self else { return }
//                self.view?.dismiss(animated: true)
//                if let error = error {
//                    print(error)
//                    self.view?.showErrorConnectingToServerAlert()
//
//                } else {
//                    self.completeOrder()
//                }
//            }
        }
    }
    
}
