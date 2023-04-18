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
    private let router: GamePageRouterProtocol
    private let shouldScrollToRegistrationOnLoad: Bool

    private var items: [GamePageItemProtocol] = []

    /// `GamePagePresenter` initializer
    /// - Parameters:
    ///   - itemFactory: Factory that creates GamePage items
    ///   - interactor: GamePage interactor
    ///   - router: GamePage screen router
    init(
        itemFactory: GamePageItemFactoryProtocol,
        interactor: GamePageInteractorProtocol,
        router: GamePageRouterProtocol,
        shouldScrollToRegistrationOnLoad: Bool
    ) {
        self.itemFactory = itemFactory
        self.interactor = interactor
        self.router = router
        self.shouldScrollToRegistrationOnLoad = shouldScrollToRegistrationOnLoad
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
        view?.startLoading()
        interactor.loadGame { [weak self] error in
            guard let self else { return }
            self.view?.stopLoading()
            if let error {
                self.view?.showAlert(error) {
                    self.router.close()
                }
                return
            }
            self.setGameInfo()
        }
    }

    private func setGameInfo() {
        view?.setTitle(interactor.getGameTitle())
        self.items = itemFactory.makeItems()
        view?.setItems(items)
        view?.setHeaderImage(path: interactor.getHeaderImagePath())
        if shouldScrollToRegistrationOnLoad {
            view?.scrollToRegistration()
        }
    }

    // MARK: - GamePageRegisterButtonOutput

    func didPressRegisterButton() {
        view?.scrollToRegistration()
    }

    // MARK: - GamePageInfoOutput

    func didTapOnMap() {
        router.showMap(for: interactor.getPlaceInfo())
    }

    // MARK: - GamePageRegistrationFieldsOutput

    func didChangeTeamCount() {
        view?.updateFirstItem(kind: .paymentCount)
    }

    // MARK: - GamePageSpecialConditionsOutput

    func didPressCheckSpecialCondition(value: String?) {
        guard let value else { return }
        view?.startLoading()
        interactor.checkSpecialCondition(value) { [weak view] isSuccess, message in
            view?.stopLoading()
            let title = isSuccess ? "Успешно" : "Ошибка"
            view?.showAlert(title: title, message: message)
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
        print("Submit!")
    }

    func agreementButtonPressed() {
        router.showUserAgreementScreen()
    }
}
