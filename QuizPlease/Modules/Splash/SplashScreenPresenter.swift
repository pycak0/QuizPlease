//
//  SplashScreenPresenter.swift
//  QuizPlease
//
//  Created by Владислав on 12.04.2021.
//  Copyright © 2021 Владислав. All rights reserved.
//

import Foundation

final class SplashScreenPresenter: SplashScreenViewOutput {

    weak var view: SplashScreenViewProtocol?

    // MARK: - Private Properties

    private let interactor: SplashScreenInteractorProtocol
    private let router: SplashScreenRouterProtocol
    /// Show loading indicator after 1.05 seconds waiting
    private let timeout = 1.0

    // MARK: - Lifecycle

    /// Initializer
    init(
        view: SplashScreenViewProtocol,
        interactor: SplashScreenInteractorProtocol,
        router: SplashScreenRouterProtocol
    ) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }

    // MARK: - SplashScreenViewOutput

    func viewDidLoad(_ view: SplashScreenViewProtocol) {
        interactor.loadAppSettings()
        setTimerForLoadingIndicator()
    }

    // MARK: - Private Methods

    private func setTimerForLoadingIndicator() {
        Timer.scheduledTimer(withTimeInterval: timeout, repeats: false) { [weak self] _ in
            self?.view?.startLoading()
        }
    }

    private func showNextScreen() {
        if interactor.wasWelcomeScreenPresented() {
            router.showMainMenu()
        } else {
            router.showWelcomeScreen()
        }
    }
}

// MARK: - SplashScreenInteractorOutput

extension SplashScreenPresenter: SplashScreenInteractorOutput {

    func didLoadAllSettings() {
        showNextScreen()
    }

    func failedToLoadSettings(error: Error) {
        print(error.localizedDescription)
        showNextScreen()
    }
}
