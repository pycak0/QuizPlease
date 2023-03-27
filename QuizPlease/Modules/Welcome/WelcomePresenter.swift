//
//  WelcomePresenter.swift
//  QuizPlease
//
//  Created by Владислав on 23.03.2023.
//  Copyright © 2023 Владислав. All rights reserved.
//

import Foundation

/// Welcome screen presenter
final class WelcomePresenter {

    // MARK: - Private Properties

    private let router: WelcomeRouterProtocol
    private let interactor: WelcomeInteractorProtocol

    private var isLoadingSettings = false

    weak var view: WelcomeViewProtocol?

    /// Initialize WelcomePresenter
    /// - Parameters:
    ///   - router: Welcome screen router
    ///   - interactor: Welcome screen interactor
    init(
        router: WelcomeRouterProtocol,
        interactor: WelcomeInteractorProtocol
    ) {
        self.router = router
        self.interactor = interactor
    }

    // MARK: - Private Methods

    private func showMainMenu() {
        view?.animateTransitionToMainMenu()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.router.showMainMenu()
        }
    }
}

// MARK: - WelcomeViewOutput

extension WelcomePresenter: WelcomeViewOutput {

    func viewDidLoad() {
        interactor.setWelcomeScreenWasPresented()
    }

    func didTapPickCity() {
        router.showCityPicker(selectedCity: AppSettings.defaultCity, delegate: self)
    }

    func didTapContinue() {
        guard !isLoadingSettings else { return }
        isLoadingSettings = true
        interactor.fetchClientSettings()
    }
}

// MARK: - PickCityVCDelegate

extension WelcomePresenter: PickCityVCDelegate {

    func didPick(_ city: City) {
        AppSettings.defaultCity = city
        view?.setSelectedCity(title: city.title)
        view?.setContinueButton(hidden: false)
    }
}

// MARK: - WelcomeInteractorOutput

extension WelcomePresenter: WelcomeInteractorOutput {

    func didFetchClientSettings() {
        isLoadingSettings = false
        showMainMenu()
    }

    func failedToFetchClientSettings(error: Error) {
        isLoadingSettings = false
        view?.showErrorLoadingClientSettings()
    }
}
