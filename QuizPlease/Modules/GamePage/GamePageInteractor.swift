//
//  GamePageInteractor.swift
//  QuizPlease
//
//  Created by Владислав on 10.04.2023.
//  Copyright © 2023 Владислав. All rights reserved.
//

import Foundation
import UIKit
import WebKit

/// GamePage interactor protocol
protocol GamePageInteractorProtocol: AnyObject,
                                     GameStatusProvider,
                                     GamePageAnnotationProvider,
                                     GamePageInfoProvider,
                                     GamePageDescriptionProvider,
                                     GamePageSubmitDataProvider,
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
        if AppSettings.inAppPaymentOnlyForOnlineGamesEnabled {
            return [.cash]
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
        gameId: String,
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
        register()

//        paymentService.launchPayment(options: PaymentOptions(
//            amount: amount,
//            description: createPaymentDescription(),
//            shopId: gameInfo.shopId ?? "",
//            transactionKey: gameInfo.paymentKey ?? "",
//            userPhoneNumber: userPhoneNumber
//        ))
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
        let defaultMessage = "Произошла ошибка при записи на игру"

        // 1. Check for payment status
        if response.shouldRedirect {
            guard
                let urlString = response.game?.url?.link,
                let url = URL(string: urlString)
            else {
                completeRegistration(success: false, message: defaultMessage)
                return
            }

            let paymentRouter = GamePagePaymentRouterImpl()
            paymentRouter.open(
                paymentUrl: url,
                completion: { [weak self] result in
                    guard let self else { return }
                    switch result {
                    case .success:
                        self.completeRegistration(success: true)
                    case let .fail(message):
                        self.completeRegistration(success: false, message: message)
                    case .canceled:
                        self.completeRegistration(success: false, message: "Оплата отменена")
                    }
                }
            )
            return
        }

        // 2. Check for response status
        var message: String = defaultMessage
        if response.isSuccess {
            message = response.successMessage ?? "Успешно"
        } else {
            message = response.successMessage ?? response.errorMessage ?? defaultMessage
        }

        completeRegistration(success: response.isSuccessfullyRegistered, message: message)
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
        gameInfo.gameDescription
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

    // MARK: - GamePageSubmitDataProvider

    func getSubmitButtonTitle() -> String {
        let registerForm = registrationService.getRegisterForm()
        return registerForm.paymentType == .online ? "Оплатить игру" : "Записаться на игру"
    }

    func getAgreementText() -> String {
        let buttonTitle = getSubmitButtonTitle()
        return "Нажимая на \"\(buttonTitle)\", " +
            "вы соглашаетесь с обработкой персональных данных и условиями пользовательского соглашения"
    }

    func getAgreementLinks() -> [TextWebLink] {
        return [
            TextWebLink(text: "персональных данных", url: AppSettings.privacyPolicyUrl),
            TextWebLink(text: "условиями пользовательского соглашения", url: AppSettings.termsOfUseUrl)
        ]
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
            discounts: registrationService
                .getSpecialConditions()
                .compactMap(\.discountInfo?.discount)
        )
    }

    func hasAnyDiscounts() -> Bool {
        !registrationService
            .getSpecialConditions()
            .compactMap(\.discountInfo?.discount)
            .isEmpty
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

private enum GamePagePaymentResult {
    case success
    case fail(String)
    case canceled
}

private protocol GamePagePaymentRouter {
    func open(paymentUrl: URL, completion: @escaping (GamePagePaymentResult) -> Void)
}

private final class GamePagePaymentRouterImpl: GamePagePaymentRouter {
    func open(paymentUrl: URL, completion: @escaping (GamePagePaymentResult) -> Void) {
        guard let topViewController = UIApplication.shared.getKeyWindow()?.topViewController else {
            completion(.fail("Не удалось открыть страницу оплаты"))
            return
        }

        let paymentViewController = GamePagePaymentViewController(
            paymentUrl: paymentUrl,
            completion: completion
        )
        let navigationController = UINavigationController(rootViewController: paymentViewController)
        navigationController.modalPresentationStyle = .fullScreen
        topViewController.present(navigationController, animated: true)
    }
}

private final class GamePagePaymentViewController: UIViewController {
    private let successPathPart = "/checkout/payments/v2/success"
    private let contractPathPart = "/checkout/payments/v2/contract"

    private let paymentUrl: URL
    private let completion: (GamePagePaymentResult) -> Void

    private var isFinished = false

    private lazy var webView: WKWebView = {
        let webView = WKWebView(frame: .zero)
        webView.navigationDelegate = self
        webView.uiDelegate = self
        webView.translatesAutoresizingMaskIntoConstraints = false
        return webView
    }()

    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()

    init(paymentUrl: URL, completion: @escaping (GamePagePaymentResult) -> Void) {
        self.paymentUrl = paymentUrl
        self.completion = completion
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        webView.load(URLRequest(url: paymentUrl))
    }

    private func setupView() {
        view.backgroundColor = .systemBackground
        navigationItem.title = "Оплата"
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: "Закрыть",
            style: .plain,
            target: self,
            action: #selector(closeTapped)
        )

        view.addSubview(webView)
        view.addSubview(activityIndicator)

        NSLayoutConstraint.activate([
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.topAnchor.constraint(equalTo: view.topAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    @objc
    private func closeTapped() {
        finish(with: .canceled)
    }

    private func finish(with result: GamePagePaymentResult) {
        guard !isFinished else { return }
        isFinished = true
        dismiss(animated: true) { [completion] in
            completion(result)
        }
    }

    private func parseResult(from url: URL) -> GamePagePaymentResult? {
        let urlString = url.absoluteString
        if urlString.contains("/records/") {
            return .canceled
        }

        let path = url.path
        if path.contains(successPathPart), urlString.contains("/success?") {
            return .success
        }

        if path.contains(contractPathPart),
           let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
           let paymentError = components.queryItems?
            .first(where: { $0.name == "paymentError" })?
            .value?
            .trimmingCharacters(in: .whitespacesAndNewlines),
           !paymentError.isEmpty {
            return .fail(paymentError)
        }

        return nil
    }
}

extension GamePagePaymentViewController: WKNavigationDelegate {
    func webView(
        _ webView: WKWebView,
        decidePolicyFor navigationAction: WKNavigationAction,
        decisionHandler: @escaping (WKNavigationActionPolicy) -> Void
    ) {
        guard let url = navigationAction.request.url else {
            decisionHandler(.allow)
            return
        }

        if let result = parseResult(from: url) {
            decisionHandler(.cancel)
            finish(with: result)
            return
        }

        decisionHandler(.allow)
    }

    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        activityIndicator.startAnimating()
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        activityIndicator.stopAnimating()
    }

    func webView(
        _ webView: WKWebView,
        didFail navigation: WKNavigation!,
        withError error: Error
    ) {
        activityIndicator.stopAnimating()
    }

    func webView(
        _ webView: WKWebView,
        didFailProvisionalNavigation navigation: WKNavigation!,
        withError error: Error
    ) {
        activityIndicator.stopAnimating()
    }
}

extension GamePagePaymentViewController: WKUIDelegate {
    func webView(
        _ webView: WKWebView,
        createWebViewWith configuration: WKWebViewConfiguration,
        for navigationAction: WKNavigationAction,
        windowFeatures: WKWindowFeatures
    ) -> WKWebView? {
        if navigationAction.targetFrame == nil {
            webView.load(navigationAction.request)
        }
        return nil
    }
}
