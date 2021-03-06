//
//  GameOrderPresenter.swift
//  QuizPlease
//
//  Created by Владислав on 13.08.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import Foundation
import YooKassaPayments

//MARK:- Presenter Protocol
protocol GameOrderPresenterProtocol {
    var game: GameInfo! { get set }
    var registerForm: RegisterForm { get set }
    var router: GameOrderRouterProtocol! { get }
    var isOnlinePaymentDefault: Bool { get }
    var isOnlyCashAvailable: Bool { get }
    var isPhoneNumberValid: Bool { get set }
    var specialConditions: [SpecialCondition] { get set }
    
    init(view: GameOrderViewProtocol, interactor: GameOrderInteractorProtocol, router: GameOrderRouterProtocol)
    
    func configureViews()
    func didPressSubmitButton()
    func countSumToPay(forPeople number: Int) -> Double
    func getPriceTextColor() -> UIColor?
    func checkCertificate()
    func checkPromocode()
    
    func didPressAddSpecialCondition()
    func didChangeSpecialCondition(newValue: String, at index: Int)
    func didPressCheckSpecialCondition(at index: Int)
    func didEndEditingSpecialCondition(at index: Int)
    func didPressDeleteSpecialCondition(at index: Int)
}

class GameOrderPresenter: GameOrderPresenterProtocol {
    weak var view: GameOrderViewProtocol?
    var interactor: GameOrderInteractorProtocol!
    var router: GameOrderRouterProtocol!
    
    var registerForm = RegisterForm()
    var game: GameInfo! {
        didSet {
            registerForm.gameId = game.id
            registerForm.paymentType = isOnlinePaymentDefault ? .online : .cash
        }
    }
    
    var isPhoneNumberValid = false
    
    var specialConditions: [SpecialCondition] = [SpecialCondition()]
    
//    private var discountType: CertificateDiscountType = .none
    private var tokenizationModule: TokenizationModuleInput?
    private var priceTextColor: UIColor?
    
    required init(view: GameOrderViewProtocol, interactor: GameOrderInteractorProtocol, router: GameOrderRouterProtocol) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
    
    var isOnlinePaymentDefault: Bool {
        let types = game.availablePaymentTypes
        return types.count == 1 && types.first! == .online
    }
    
    var isOnlyCashAvailable: Bool {
        let types = game.availablePaymentTypes
        return types.count == 1 && types.first! == .cash
    }
    
    func configureViews() {
        view?.configureTableView()
        if let path = game.backgroundImagePath?.pathProof {
            view?.setBackgroundImage(with: path)
        } else {
            print(">>>\n>>> No background image path for game with id \(game.id)\n>>>")
        }
    }
    
    func countSumToPay(forPeople number: Int) -> Double {
        registerForm.countPaidOnline = number
        var price = Double(game.priceNumber ?? 0)
        var peopleToPay = Double(number)
        
        let (peopleFree, percentFraction) = countAllDiscounts()
        let peopleForFree = Double(peopleFree)
        
        if peopleForFree >= peopleToPay {
            return 0
        }
        peopleToPay -= peopleForFree
        
        if game.isOnlineGame {
            ///Процентный промокод работает только на онлайн-играх, а `price` на них считается за всю команду
            let percentDiscountSum = price * percentFraction
            price = max(price - percentDiscountSum, 0)
        } else {
            ///Разделение оплаты по количеству человек есть только на офлайн-играх
            price *= peopleToPay
        }
        
        return price
    }
    
    private func countAllDiscounts() -> (totalPeopleForFree: Int, totalPercentFraction: Double) {
        let discounts = specialConditions.compactMap(\.discountInfo?.discount)
        var percentFraction = 0.0
        var peopleForFree = 0
        for discount in discounts {
            switch discount {
            case let .percent(fraction):
                percentFraction += fraction
            case let .somePeopleForFree(amount):
                if peopleForFree != Int.max {
                    peopleForFree += amount
                }
            case let .certificateDiscount(type):
                switch type {
                case .allTeamFree:
                    peopleForFree = Int.max
                case let .numberOfPeopleForFree(amount):
                    if peopleForFree != Int.max {
                        peopleForFree += amount
                    }
                case .none:
                    continue
                }
            case .none:
                continue
            }
        }
        
        priceTextColor = (peopleForFree > 0 || percentFraction > 0) ? .lightGreen : nil
        return (peopleForFree, percentFraction)
    }
    
    func getPriceTextColor() -> UIColor? {
        return priceTextColor
    }
    
    //MARK:- Special Conditions
    func didPressAddSpecialCondition() {
        specialConditions.append(SpecialCondition())
        view?.addCertificateCell()
    }
    
    func didChangeSpecialCondition(newValue: String, at index: Int) {
        specialConditions[index].value = newValue
        ///If the value was chagned, we can't guarantee that the new condition is still valid
        specialConditions[index].discountInfo = nil
    }
    
    func didEndEditingSpecialCondition(at index: Int) {
        guard let number = registerForm.countPaidOnline else { return }
        view?.setPrice(countSumToPay(forPeople: number))
    }
    
    func didPressCheckSpecialCondition(at index: Int) {
        guard let value = specialConditions[index].value else { return }
        view?.startLoading()
        interactor.checkSpecialCondition(value, forGameWithId: game.id, selectedTeamName: registerForm.teamName)
    }
    
    func didPressDeleteSpecialCondition(at index: Int) {
        ///Should not remove the first certificate cell
        guard index > 0 else { return }
        specialConditions.remove(at: index)
        view?.removeCertificateCell(at: index)
    }
    
    //MARK:- Check Certificate
    func checkCertificate() {
//        guard let cert = registerForm.certificates else { return }
//        view?.startLoading()
//        interactor.checkCertificate(forGameId: game.id, certificate: cert) { [weak self] (result) in
//            guard let self = self else { return }
//            self.view?.stopLoading()
//            switch result {
//            case let .failure(error):
//                print(error)
//                self.view?.showErrorConnectingToServerAlert()
//            case let .success(response):
//                self.discountType = response.discountType
//                self.view?.showSimpleAlert(title: "Проверка сертификата", message: response.message ?? "Не удалось получить статус проверки")
//                if let number = self.registerForm.countPaidOnline {
//                    self.view?.setPrice(self.countSumToPay(forPeople: number))
//                }
//            }
//        }
    }
    
    func checkPromocode() {
//        guard let promocode = registerForm.promocode else { return }
//        view?.startLoading()
//        interactor.checkPromocode(
//            promocode,
//            teamName: registerForm.teamName,
//            forGameWithId: game.id
//        )
    }
        
    //MARK:- Submit Button Action
    func didPressSubmitButton() {
        view?.endEditing()
        guard registerForm.isValid else {
            if registerForm.email.isEmpty {
                view?.showSimpleAlert(
                    title: "Заполнены не все необходимые поля",
                    message: "Пожалуйста, заполните все поля, отмеченные звездочкой, и проверьте их корректность"
                )
            } else if !registerForm.email.isValidEmail {
                view?.showSimpleAlert(
                    title: "Некорректный e-mail",
                    message: "Пожалуйста, введите корректный адрес и попробуйте еще раз"
                ) { (okAction) in
                    self.view?.editEmail()
                }
                
            } else if !isPhoneNumberValid {
                view?.showSimpleAlert(
                    title: "Некорректный номер телефона",
                    message: "Пожалуйста, введите корректный номер и попробуйте еще раз"
                ) { (okAction) in
                    self.view?.editPhone()
                }
            }
            
            return
        }
        
        let count = registerForm.countPaidOnline ?? 0
        let paymentSum = Double(countSumToPay(forPeople: count))
        if registerForm.paymentType == .online && paymentSum > 0 {
            router.showPaymentView(
                provider: YooMoneyPaymentProvider(),
                withSum: paymentSum,
                description: createPaymentDescription(),
                delegate: self
            )
        } else {
            register()
        }
    }
    
    //MARK:- Register
    private func register() {
        view?.startLoading()
        interactor.register(
            with: registerForm,
            specialConditions: specialConditions
        ) { [weak self] registerResponse in
            guard let self = self else { return }
            self.view?.stopLoading()
            guard let response = registerResponse else {
                self.view?.showErrorConnectingToServerAlert()
                return
            }

            let title = "Запись на игру"
            var message: String = "Произошла ошибка при записи на игру"
            
            if response.shouldRedirect {
                if let url = response.link {
                    self.tokenizationModule?.start3dsProcess(requestUrl: url.absoluteString)
                } else {
                    self.view?.dismiss(animated: true) {
                        self.view?.showSimpleAlert(title: title, message: message)
                    }
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
                message = response.successMessage ?? "Успешно"
            } else {
                message = response.successMessage ?? response.errorMessage ?? "Произошла ошибка при записи на игру"
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
    
    private func createPaymentDescription() -> String {
        let name = game.fullTitle.trimmingCharacters(in: .whitespaces)
        return "Игра \"\(name)\": \(game.blockData), \(game.priceDetails)"
    }
}

//MARK:- GameOrderInteractorOutput
extension GameOrderPresenter: GameOrderInteractorOutput {
    func interactor(_ interactor: GameOrderInteractorProtocol?, didCheckPromocodeWith response: PromocodeResponse) {
        view?.stopLoading()
        let title = response.isSuccess ? "Успешно" : "Ошибка"
        view?.showSimpleAlert(title: title, message: response.message)
    }
    
    func interactor(_ interactor: GameOrderInteractorProtocol?, errorOccured error: SessionError) {
        view?.stopLoading()
        view?.showErrorConnectingToServerAlert()
    }
    
    func interactor(_ interactor: GameOrderInteractorProtocol?, didCheckSpecialCondition value: String, with response: SpecialCondition.Response) {
        view?.stopLoading()
        switch response.discountInfo.kind {
        case .promocode:
            if specialConditions.filter({ $0.discountInfo?.kind == .promocode }).count > 0 {
                view?.showSimpleAlert(
                    title: "Ошибка",
                    message: "На одну игру возможно использовать только один промокод"
                )
                return
            }
        default:
            break
        }
        if let index = specialConditions.firstIndex(where: { $0.value == value }) {
            specialConditions[index].discountInfo = response.discountInfo
        }
        if let number = registerForm.countPaidOnline {
            self.view?.setPrice(self.countSumToPay(forPeople: number))
        }
        let title = response.success ? "Успешно" : "Ошибка"
        view?.showSimpleAlert(title: title, message: response.message)
    }
}

//MARK:- TokenizationModuleOutput
extension GameOrderPresenter: TokenizationModuleOutput {
    func didFinish(on module: TokenizationModuleInput, with error: YooKassaPaymentsError?) {
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
        }
    }
}
