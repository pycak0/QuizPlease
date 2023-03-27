//
//  SplashScreenInteractor.swift
//  QuizPlease
//
//  Created by Владислав on 12.04.2021.
//  Copyright © 2021 Владислав. All rights reserved.
//

import Foundation

/// Splash Screen Interactor protocol
protocol SplashScreenInteractorProtocol {

    /// Load all required settings for the app start
    func loadAppSettings()

    /// Indicates whether the Welcome screen was ever presented or not
    func wasWelcomeScreenPresented() -> Bool
}

/// Interactor output protocol
protocol SplashScreenInteractorOutput: AnyObject {

    /// Method is called when all the necessary settings were loaded successfully
    func didLoadAllSettings()

    /// Method indicates that some of the settings were not loaded
    func failedToLoadSettings(error: Error)
}

/// Splash Screen Interactor
final class SplashScreenInteractor: SplashScreenInteractorProtocol {

    private let defaultsManager = DefaultsManager.shared
    private let utilities = Utilities.main
    private let dispatchGroup = DispatchGroup()
    /// Time that interactor just waits for the user to look at the splash screen
    private let waitingTime = 0.7

    lazy var workItem: DispatchWorkItem = DispatchWorkItem { [weak self] in
        self?.interactorOutput?.didLoadAllSettings()
    }

    weak var interactorOutput: SplashScreenInteractorOutput?

    // MARK: - SplashScreenInteractorProtocol

    func loadAppSettings() {
        utilities.setDefaultCityFromCache()
        utilities.setClientSettingsFromCache()
        justWaitForUserToLookAtSplashScreen()
        updateUserToken()
        fetchClientSettingsIfNeeded()
        dispatchGroup.notify(queue: .main, work: workItem)
    }

    func wasWelcomeScreenPresented() -> Bool {
        defaultsManager.wasWelcomeScreenPresented()
    }

    // MARK: - Private Methods

    private func justWaitForUserToLookAtSplashScreen() {
        dispatchGroup.enter()
        Timer.scheduledTimer(withTimeInterval: waitingTime, repeats: false) { [self] _ in
            dispatchGroup.leave()
        }
    }

    private func updateUserToken() {
        dispatchGroup.enter()
        utilities.updateToken { [weak self] in
            guard let self = self else { return }
            self.dispatchGroup.leave()
        }
    }

    private func fetchClientSettingsIfNeeded() {
        // Fetch client settings only if Welcome screen with choosing default city was already presented
        // This is because user must select a default city on the Welcome screen
        // Therefore, Welcome screen will always load client settings for this city on its own
        // before showing the main screen
        guard defaultsManager.wasWelcomeScreenPresented() else { return }
        dispatchGroup.enter()
        utilities.fetchClientSettings { [weak self] fetchResult in
            guard let self = self else { return }
            switch fetchResult {
            case let .failure(error):
                self.workItem.cancel()
                self.interactorOutput?.failedToLoadSettings(error: error)
            case .success:
                break
            }
            self.dispatchGroup.leave()
        }
    }
}
