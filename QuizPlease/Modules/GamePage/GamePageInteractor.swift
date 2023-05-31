//
//  GamePageInteractor.swift
//  QuizPlease
//
//  Created by Владислав on 10.04.2023.
//  Copyright © 2023 Владислав. All rights reserved.
//

import Foundation

/// GamePage interactor protocol
protocol GamePageInteractorProtocol: AnyObject,
                                     GameStatusProvider,
                                     GamePageAnnotationProvider,
                                     GamePageInfoProvider,
                                     GamePageDescriptionProvider,
                                     GamePageSubmitButtonTitleProvider,
                                     GamePagePaymentInfoProvider {

    /// Load game info
    func loadGame(complpetion: @escaping (Error?) -> Void)

    /// Get Game full title
    func getGameTitle() -> String

    /// Path of backgorund image in the header of GamePage
    func getHeaderImagePath() -> String

    /// Get Place information
    func getPlaceInfo() -> Place

    /// Check special condition for discount
    func checkSpecialCondition(_ value: String, completion: @escaping (Bool, String) -> Void)

    /// Check whether register form is valid
    func validateRegisterForm(completion: @escaping (RegisterFormValidationResult) -> Void)

    /// Start registration process
    func submitRegistration()
}

/// GamePage interactor output protocol
protocol GamePageInteractorOutput: AnyObject {

    /// Registration process did finish / stop / cancel
    func didRegisterWithResult(_ result: GameRegistrationResult)

    /// Network error occured
    func didFailWithError(_ error: NetworkServiceError)
}

/// GamePage interactor
final class GamePageInteractor: GamePageInteractorProtocol {

    weak var output: GamePageInteractorOutput?

    // MARK: - Private Properties

    private var gameInfo: GameInfo
    private var parsedHtmlDescription: NSAttributedString?
    private let gameInfoLoader: GameInfoLoader
    private let placeGeocoder: PlaceGeocoderProtocol
    private let registrationService: RegistrationServiceProtocol
    private let paymentSumCalculator: PaymentSumCalculator
    private let paymentService: PaymentServiceProtocol

    var availablePaymentTypes: [PaymentType] {
        if gameInfo.isOnlineGame {
            return gameInfo.availablePaymentTypes
        }
        if gameInfo.gameStatus == .reserveAvailable {
            return [.cash]
        }
        if registrationService.getRegisterForm().count > gameInfo.vacantPlaces {
            return [.cash]
        }
        return gameInfo.availablePaymentTypes
    }

    // MARK: - Lifecycle

    /// GamePage interactor initializer
    /// - Parameters:
    ///   - gameId: Game identifier
    ///   - gameInfoLoader: Service that loads Game info
    ///   - placeGeocoder: Service that provides `Place` coordinates
    ///   - registrationService: Service that manages register form
    ///   - paymentSumCalculator: Service that calculates payment sum for the game
    ///   - paymentService: Payment service
    init(
        gameId: Int,
        gameInfoLoader: GameInfoLoader,
        placeGeocoder: PlaceGeocoderProtocol,
        registrationService: RegistrationServiceProtocol,
        paymentSumCalculator: PaymentSumCalculator,
        paymentService: PaymentServiceProtocol
    ) {
        var gameInfo = GameInfo()
        gameInfo.id = gameId
        self.gameInfo = gameInfo
        self.gameInfoLoader = gameInfoLoader
        self.placeGeocoder = placeGeocoder
        self.registrationService = registrationService
        self.paymentSumCalculator = paymentSumCalculator
        self.paymentService = paymentService
    }

    // MARK: - Private Methods

    private func parseHtmlDescription(text: String?, completion: @escaping () -> Void) {
        DispatchQueue.global().async { [weak self] in
            self?.parsedHtmlDescription = text?.htmlFormatted()?.trimmingWhitespacesAndNewlines()
            DispatchQueue.main.async {
                completion()
            }
        }
    }

    /// Calculates payment sum. If payment is needed, launches payment process.
    /// If not, registers immediately.
    private func registerWithOnlinePayment() {
        let registerForm = registrationService.getRegisterForm()
        let paymentSum = calculatePaymentSum()
        if gameInfo.isOnlineGame {
            // В онлайн-играх оплата производится всегда за команду,
            // отдельно количество оплаченных участников не указывается
            registerForm.countPaidOnline = nil
            registerForm.surcharge = nil

        } else if let selectedToPay = registerForm.countPaidOnline {
            // Для корректной работы бэка (о да, опять костыли 🙄)
            // нам нужно указать только то количество человек,
            // за которых действительно нужно заплатить.
            //
            // То есть необходимо отнять от общего числа выбранных для оплаты людей
            // количество тех, кто пройдет бесплатно
            let peopleForFree = paymentSumCalculator
                .calculateDiscounts(discounts: getDiscounts())
                .totalPeopleForFree
            registerForm.surcharge = selectedToPay - peopleForFree
        }

        // Если выбрана оплата онлайн, и оплата действительно требуется,
        // то поднимаем юкассу и генерируем платежный токен
        if paymentSum > 0 {
            launchPayment(amount: paymentSum)
        } else {
            // Если платеж не требуется, то для корректной отработки бэка
            // нужно указать тип оплаты "на игре" / "наличными"
            // и сразу отправить запрос на регистрацию без платежного токена
            registerForm.paymentType = .cash
            register()
        }
    }

    /// Launch payment process with given amount.
    /// - Parameter amount: payment amount.
    private func launchPayment(amount: Double) {
        let userPhoneNumber = registrationService.getRegisterForm().phone
            .replacingOccurrences(of: "-", with: " ")
            .replacingOccurrences(of: "(", with: "")
            .replacingOccurrences(of: ")", with: "")

        if gameInfo.shopId?.isEmpty ?? true {
            print("⚠️ [\(Self.self)|\(#line)] Shop id is empty. Production payment will fail")
        }
        if gameInfo.paymentKey?.isEmpty ?? true {
            print("❌ [\(Self.self)|\(#line)] Payment key is empty. Payment SDK launch will fail")
        }

        paymentService.launchPayment(options: PaymentOptions(
            amount: amount,
            description: createPaymentDescription(),
            shopId: gameInfo.shopId,
            transactionKey: gameInfo.paymentKey ?? "",
            userPhoneNumber: userPhoneNumber
        ))
    }

    private func createPaymentDescription() -> String {
        let name = gameInfo.fullTitle.trimmingCharacters(in: .whitespaces)
        return "Игра \"\(name)\": \(gameInfo.blockData), \(gameInfo.priceDetails)"
    }

    private func register() {
        registrationService.sendRegistrationRequest { [weak self] result in
            guard let self else { return }
            switch result {
            case let .failure(error):
                self.paymentService.closePayment {
                    self.output?.didFailWithError(error)
                }
            case let .success(response):
                self.processRegistrationResponse(response)
            }
        }
    }

    private func processRegistrationResponse(_ response: GameOrderResponse) {
        var message: String = "Произошла ошибка при записи на игру"

        // 1. Check for payment status
        if response.shouldRedirect {
            if let url = response.link {
                paymentService.startConfirmation(url.absoluteString)
            } else {
                self.paymentService.closePayment {
                    self.completeRegistration(success: false, message: message)
                }
            }
            return

        }

        // 2. Check for response status
        if response.isSuccess {
            message = response.successMessage ?? "Успешно"
        } else {
            message = response.successMessage ?? response.errorMessage ?? "Произошла ошибка при записи на игру"
        }

        paymentService.closePayment {
            self.completeRegistration(success: response.isSuccessfullyRegistered, message: message)
        }
    }

    private func completeRegistration(success: Bool, message: String? = nil) {
        let result = GameRegistrationResult(
            isSuccess: success,
            message: message,
            options: .init(
                gameInfo: gameInfo,
                teamCount: registrationService.getRegisterForm().count
            )
        )
        output?.didRegisterWithResult(result)
    }

    private func getDiscounts() -> [DiscountKind] {
        registrationService
            .getSpecialConditions()
            .compactMap(\.discountInfo?.discount)
    }

    // MARK: - GamePageInteractorProtocol

    func loadGame(complpetion: @escaping (Error?) -> Void) {
        gameInfoLoader.load(gameId: gameInfo.id) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let game):
                self.gameInfo = game
                let customFieldModels = game.customFields?.map { CustomFieldModel(data: $0) } ?? []
                self.registrationService.setCustomFields(customFieldModels)
                self.registrationService.getRegisterForm().paymentType = self.availablePaymentTypes.first ?? .cash
                self.parseHtmlDescription(text: game.optionalDescription) {
                    complpetion(nil)
                }
                return
            case .failure(let error):
                complpetion(error)
            }
        }
    }

    func getGameTitle() -> String {
        return gameInfo.fullTitle
    }

    func getHeaderImagePath() -> String {
        return gameInfo.backgroundImagePath?.pathProof ?? ""
    }

    func getPlaceInfo() -> Place {
        return gameInfo.placeInfo
    }

    func checkSpecialCondition(_ value: String, completion: @escaping (Bool, String) -> Void) {
        registrationService.checkSpecialCondition(value, completion: completion)
    }

    func validateRegisterForm(completion: @escaping (RegisterFormValidationResult) -> Void) {
        registrationService.validateRegisterForm(completion: completion)
    }

    func submitRegistration() {
        let registerForm = registrationService.getRegisterForm()
        if registerForm.paymentType == .online {
            registerWithOnlinePayment()
        } else {
            registerForm.countPaidOnline = nil
            register()
        }
    }

    // MARK: - GameStatusProvider

    func getGameStatus() -> GameStatus {
        gameInfo.gameStatus ?? .noPlaces
    }

    // MARK: - GamePageAnnotationProvider

    func getAnnotation() -> String {
        gameInfo.description
    }

    // MARK: - GamePageInfoProvider

    func getInfo() -> GamePageInfoModel {
        GamePageInfoModel(game: gameInfo)
    }

    func getPlaceAnnotation(completion: @escaping (Place) -> Void) {
        let place = gameInfo.placeInfo
        placeGeocoder.getCoordinate(place) { [weak place] coordinate in
            guard let place else { return }
            place.coordinate = coordinate
            completion(place)
        }
    }

    // MARK: - GamePageDescriptionProvider

    func getDescription() -> NSAttributedString? {
        parsedHtmlDescription ?? gameInfo.optionalDescription.map { NSAttributedString(string: $0) }
    }

    // MARK: - SpecialConditionsProvider

    var canAddSpecialCondition: Bool {
        registrationService.canAddSpecialCondition
    }

    func addSpecialCondition() -> SpecialCondition? {
        registrationService.addSpecialCondition()
    }

    // MARK: - GamePageSubmitButtonTitleProvider

    func getSubmitButtonTitle() -> String {
        let registerForm = registrationService.getRegisterForm()
        return registerForm.paymentType == .online ? "Оплатить игру" : "Записаться на игру"
    }

    // MARK: - GamePagePaymentInfoProvider

    func getAvailablePaymentTypes() -> [PaymentType] {
        availablePaymentTypes
    }

    func getSelectedPaymentType() -> PaymentType {
        registrationService.getRegisterForm().paymentType
    }

    func setPaymentType(_ type: PaymentType) {
        registrationService.getRegisterForm().paymentType = type
    }

    func supportsSelectPaidPeopleCount() -> Bool {
        !gameInfo.isOnlineGame
    }

    func getNumberOfPeopleInTeam() -> Int {
        registrationService.getRegisterForm().count
    }

    func getSelectedNumberOfPeopleToPay() -> Int {
        let registerForm = registrationService.getRegisterForm()
        if let count = registerForm.countPaidOnline {
            return count
        }
        registerForm.countPaidOnline = registerForm.count
        return registerForm.count
    }

    func setNumberOfPeopleToPay(_ number: Int) {
        registrationService.getRegisterForm().countPaidOnline = number
    }

    func calculatePaymentSum() -> Double {
        let registerForm = registrationService.getRegisterForm()
        return paymentSumCalculator.calculateSumToPay(
            forPeople: registerForm.countPaidOnline ?? registerForm.count,
            gamePrice: gameInfo.priceNumber ?? 0,
            isOnlineGame: gameInfo.isOnlineGame,
            discounts: getDiscounts()
        )
    }

    func hasAnyDiscounts() -> Bool {
        !getDiscounts().isEmpty
    }
}

// MARK: - PaymentServiceOutput

extension GamePageInteractor: PaymentServiceOutput {

    func didCreatePaymentToken(_ paymentToken: String) {
        registrationService.getRegisterForm().paymentToken = paymentToken
        register()
    }

    func didCancelPayment() {
        completeRegistration(success: false)
    }

    func didConfirmPaymentSuccessfully() {
        completeRegistration(success: true)
    }
}
