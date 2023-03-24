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

    weak var view: WelcomeViewProtocol?
    private let router: WelcomeRouterProtocol

    /// Initialize WelcomePresenter
    /// - Parameter router: Welcome screen router protocol
    init(router: WelcomeRouterProtocol) {
        self.router = router
    }
}

// MARK: - WelcomeViewOutput

extension WelcomePresenter: WelcomeViewOutput {

    func viewDidLoad() {
        DefaultsManager.shared.setWelcomeScreenWasPresented()
    }

    func didTapPickCity() {
        router.showCityPicker(selectedCity: AppSettings.defaultCity, delegate: self)
    }

    func didTapContinue() {
        view?.animateTransitionToMainMenu()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.router.showMainMenu()
        }
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
