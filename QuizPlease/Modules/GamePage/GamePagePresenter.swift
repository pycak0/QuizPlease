//
//  GamePagePresenter.swift
//  QuizPlease
//
//  Created by Владислав on 10.04.2023.
//  Copyright © 2023 Владислав. All rights reserved.
//

import Foundation

/// GamePage presenter
final class GamePagePresenter {

    weak var view: GamePageViewInput?

    // MARK: - Private Properties

    private let itemFactory: GamePageItemFactoryProtocol
    private let interactor: GamePageInteractorProtocol
    private let analyticsService: AnalyticsService
    private let router: GamePageRouterProtocol
    private let shouldScrollToRegistrationOnLoad: Bool

    private var items: [GamePageItemProtocol] = []

    // MARK: - Lifecycle

    /// `GamePagePresenter` initializer
    /// - Parameters:
    ///   - itemFactory: Factory that creates GamePage items
    ///   - interactor: GamePage interactor
    ///   - analyticsService: Service that sends analytic events
    ///   - router: GamePage screen router
    ///   - shouldScrollToRegistrationOnLoad: should scroll to registration section
    ///   after screen was loaded
    init(
        itemFactory: GamePageItemFactoryProtocol,
        interactor: GamePageInteractorProtocol,
        analyticsService: AnalyticsService,
        router: GamePageRouterProtocol,
        shouldScrollToRegistrationOnLoad: Bool
    ) {
        self.itemFactory = itemFactory
        self.interactor = interactor
        self.analyticsService = analyticsService
        self.router = router
        self.shouldScrollToRegistrationOnLoad = shouldScrollToRegistrationOnLoad
    }

    // MARK: - Private Methods

    private func setGameInfo() {
        view?.setTitle(interactor.getGameTitle())
        self.items = itemFactory.makeItems()
        view?.setItems(items)
        view?.setHeaderImage(path: interactor.getHeaderImagePath())
        if shouldScrollToRegistrationOnLoad {
            view?.scrollToItem(kind: .registrationHeader)
        }
    }

    private func processErrors(_ errors: [RegisterFormValidationResult.Error]) {
        guard let error = errors.first else { return }
        view?.showAlert(title: error.title, message: error.message) { [weak self] in
            self?.alertTapActionOnError(error)
        }
    }

    private func alertTapActionOnError(_ error: RegisterFormValidationResult.Error) {
        switch error {
        case .email:
            view?.editItem(kind: .email)
        case .phone:
            view?.editItem(kind: .phone)
        case .invalidTeamName:
            view?.editItem(kind: .teamName)
        case .unknown, .network, .someFieldsEmpty:
            break
        case let .customFieldEmpty(field):
            view?.editItem(kind: .customField(field.data.name))
        }
    }
}

// MARK: - GamePageViewOutput

extension GamePagePresenter: GamePageViewOutput,
                             GamePageRegisterButtonOutput,
                             GamePageInfoOutput,
                             GamePageRegistrationFieldsOutput,
                             GamePageSpecialConditionsOutput,
                             GamePagePaymentSectionOutput,
                             GamePageSubmitOutput {

    func viewDidLoad() {
        analyticsService.sendEvent(.gamePageOpen)
        view?.startLoading()
        interactor.loadGame { [weak self] error in
            guard let self else { return }
            self.view?.stopLoading()
            if error != nil {
                self.view?.showErrorConnectingToServerAlert {
                    self.router.close()
                }
                return
            }
            self.setGameInfo()
        }
    }

    // MARK: - GamePageRegisterButtonOutput

    func didPressRegisterButton() {
        view?.scrollToItem(kind: .registrationHeader)
    }

    // MARK: - GamePageInfoOutput

    func didTapOnMap() {
        router.showMap(for: interactor.getPlaceInfo())
    }

    // MARK: - GamePageRegistrationFieldsOutput

    func didChangeTeamCount() {
        view?.updateFirstItem(kind: .paymentCount)
    }

    func updateField(kind: GamePageItemKind) {
        view?.updateFirstItem(kind: kind)
    }

    // MARK: - GamePageSpecialConditionsOutput

    func didPressCheckSpecialCondition(value: String?) {
        guard let value else { return }
        view?.startLoading()
        interactor.checkSpecialCondition(value) { [weak view] isSuccess, message in
            view?.stopLoading()
            let title = isSuccess ? "Успешно" : "Ошибка"
            view?.showAlert(title: title, message: message, handler: nil)
            view?.updateFirstItem(kind: .paymentSum)
        }
    }

    func didEndEditingSpecialCondition() {
        view?.updateFirstItem(kind: .paymentSum)
    }

    // MARK: - GamePagePaymentSectionOutput

    func didChangePaymentType() {
        view?.updateFirstItem(kind: .submit)
    }

    func didChangePaymentCount() {
        view?.updateFirstItem(kind: .paymentSum)
    }

    // MARK: - GamePageSubmitOutput

    func submitButtonPressed() {
        analyticsService.sendEvent(.beginRegistration)
        view?.startLoading()

        // 1. Validate
        interactor.validateRegisterForm { [weak self] result in
            guard let self else { return }
            guard result.isValid else {
                self.view?.stopLoading()
                self.processErrors(result.errors)
                return
            }

            // 2. Start registration
            self.interactor.submitRegistration()
        }
    }

    func agreementButtonPressed() {
        router.showUserAgreementScreen()
    }
}

// MARK: - GamePageInteractorOutput

extension GamePagePresenter: GamePageInteractorOutput {

    func didRegisterWithResult(_ result: GameRegistrationResult) {
        view?.stopLoading()
        let completion = { [weak self, result] in
            guard let self else { return }
            if result.isSuccess {
                self.analyticsService.sendEvent(.registrationSuccess)
                self.router.showCompletionScreen(options: result.options, delegate: self)
            }
        }
        guard let message = result.message else {
            completion()
            return
        }
        view?.showAlert(
            title: "Запись на игру",
            message: message,
            handler: completion
        )
    }

    func didFailWithError(_ error: NetworkServiceError) {
        view?.stopLoading()
        view?.showErrorConnectingToServerAlert(handler: nil)
    }
}

// MARK: - GameOrderCompletionDelegate

extension GamePagePresenter: GameOrderCompletionDelegate {

    func didPressDismissButton(in vc: GameOrderCompletionVC) {
        vc.dismiss(animated: true)
        router.close()
    }
}
