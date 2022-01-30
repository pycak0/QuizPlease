//
//  GameOrderPresenter.swift
//  QuizPlease
//
//  Created by Владислав on 13.08.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import Foundation
import YooKassaPayments

//MARK: - Presenter Protocol
protocol GameOrderPresenterProtocol {
    var router: GameOrderRouterProtocol! { get }
    var view: GameOrderViewProtocol? { get }
    var interactor: GameOrderInteractorProtocol! { get }
    
    var game: GameInfo { get }
    var registerForm: RegisterForm { get }
    
    var isOnlinePaymentDefault: Bool { get }
    var isOnlyCashAvailable: Bool { get }
    var isPhoneNumberValid: Bool { get set }
    var specialConditions: [SpecialCondition] { get set }
    
    var maximumSpecialConditionsAmount: Int { get }
        
    func configureViews()
    func didPressSubmitButton()
    func didPressTermsOfUse()
    func countSumToPay(forPeople number: Int) -> Double
    func getPriceTextColor() -> UIColor?
    
    func didPressAddSpecialCondition()
    func didChangeSpecialCondition(newValue: String, at index: Int)
    func didPressCheckSpecialCondition(at index: Int)
    func didEndEditingSpecialCondition(at index: Int)
    func didPressDeleteSpecialCondition(at index: Int)
    
    func didTapOnMap()
}

class GameOrderPresenter: GameOrderPresenterProtocol {
    weak var view: GameOrderViewProtocol?
    var interactor: GameOrderInteractorProtocol!
    var router: GameOrderRouterProtocol!
    
    let registerForm: RegisterForm
    var game: GameInfo
    
    var isPhoneNumberValid = false
    
    var specialConditions: [SpecialCondition] = [SpecialCondition()]
    
    let maximumSpecialConditionsAmount = 9
    
//    private var discountType: CertificateDiscountType = .none
    private var priceTextColor: UIColor?
    
    private var tokenizationModule: TokenizationModuleInput?
    
    required init(
        view: GameOrderViewProtocol,
        interactor: GameOrderInteractorProtocol,
        router: GameOrderRouterProtocol,
        registerForm: RegisterForm,
        gameInfo: GameInfo
    ) {
        self.view = view
        self.interactor = interactor
        self.router = router
        self.game = gameInfo
        self.registerForm = registerForm
        self.registerForm.paymentType = isOnlinePaymentDefault ? .online : .cash
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
            print(">>>\n>>> No background image path for game with id '\(game.id ?? -1)'\n>>>")
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
    
    // MARK: - Special Conditions
    
    func didPressAddSpecialCondition() {
        guard specialConditions.count < maximumSpecialConditionsAmount else { return }
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
        guard
            specialConditions.count > 1,
            index >= specialConditions.startIndex,
            index < specialConditions.endIndex
        else { return }
        specialConditions.remove(at: index)
        view?.removeCertificateCell(at: index)
    }
    
    func didTapOnMap() {
        router.showMap(for: game.placeInfo)
    }
        
    // MARK: - Submit Button Action
    
    func didPressTermsOfUse() {
        view?.openSafariVC(
            with: AppSettings.termsOfUseUrl,
            delegate: nil,
            autoReaderView: true
        )
    }
    
    func didPressSubmitButton() {
        view?.endEditing()
        guard isPhoneNumberValid, registerForm.isValid else {
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
            } else {
                view?.showSimpleAlert(
                    title: "Произошла неизвестная ошибка",
                    message: "Error status code 40"
                )
            }
            return
        }
        
        let count = registerForm.countPaidOnline ?? 0
        let paymentSum = Double(countSumToPay(forPeople: count))
        let userPhoneNumber = registerForm.phone
            .replacingOccurrences(of: "-", with: " ")
            .replacingOccurrences(of: "(", with: "")
            .replacingOccurrences(of: ")", with: "")

        if registerForm.paymentType == .online && paymentSum > 0 {
            if game.shopId?.isEmpty ?? true {
                print("⚠️ [\(Self.self)|\(#line)] Shop id is empty. Production payment will fail")
            }
            if game.paymentKey?.isEmpty ?? true {
                print("❌ [\(Self.self)|\(#line)] Payment key is empty. Payment SDK launch will fail")
            }
            router.showPaymentView(
                provider: YooMoneyPaymentProvider(
                    delegate: self
                ),
                withOptions: PaymentOptions(
                    amount: paymentSum,
                    description: createPaymentDescription(),
                    shopId: game.shopId ?? "",
                    transactionKey: game.paymentKey ?? "",
                    userPhoneNumber: userPhoneNumber
                )
            )
        } else if registerForm.paymentType == .online && paymentSum <= 0 {
            registerForm.paymentType = .cash
            register()
        } else {
            register()
        }
    }
    
    // MARK: - Register
    private func register(paymentMethod: PaymentMethodType? = nil) {
        view?.startLoading()
        interactor.register(
            with: registerForm,
            specialConditions: specialConditions,
            paymentMethod: paymentMethod
        )
    }
    
    private func completeOrder() {
        router.showCompletionScreen(with: game, numberOfPeopleInTeam: registerForm.count)
    }
    
    private func createPaymentDescription() -> String {
        let name = game.fullTitle.trimmingCharacters(in: .whitespaces)
        return "Игра \"\(name)\": \(game.blockData), \(game.priceDetails)"
    }
}

// MARK: - GameOrderInteractorOutput

extension GameOrderPresenter: GameOrderInteractorOutput {
    func interactor(_ interactor: GameOrderInteractorProtocol?, didRegisterWithResponse response: GameOrderResponse, paymentMethod: PaymentMethodType?) {
        view?.stopLoading()
        let title = "Запись на игру"
        var message: String = "Произошла ошибка при записи на игру"
        
        if response.shouldRedirect {
            if let url = response.link, let module = tokenizationModule, let paymentMethod = paymentMethod {
                module.startConfirmationProcess(
                    confirmationUrl: url.absoluteString,
                    paymentMethodType: paymentMethod
                )
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
    
    func interactor(_ interactor: GameOrderInteractorProtocol?, errorOccured error: NetworkServiceError) {
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

// MARK: - TokenizationModuleOutput
extension GameOrderPresenter: TokenizationModuleOutput {
    func didFinish(on module: TokenizationModuleInput, with error: YooKassaPaymentsError?) {
        DispatchQueue.main.async {
            self.view?.dismiss(animated: true)
        }
        print("Error:", error as Any)
    }
    
    func tokenizationModule(_ module: TokenizationModuleInput, didTokenize token: Tokens, paymentMethodType: PaymentMethodType) {
        DispatchQueue.main.async {
            self.registerForm.paymentToken = token.paymentToken
            self.tokenizationModule = module
            self.register(paymentMethod: paymentMethodType)
        }
    }
    
    func didSuccessfullyConfirmation(paymentMethodType: PaymentMethodType) {
        completeAfterConfirm()
        print("Payment successfully confirmed")
    }
    
    func didSuccessfullyPassedCardSec(on module: TokenizationModuleInput) {
        completeAfterConfirm()
        print("3-D Secure process successfully passed")
    }
    
    private func completeAfterConfirm() {
        DispatchQueue.main.async {
            self.view?.dismiss(animated: true) {
                self.completeOrder()
            }
        }
    }
}
