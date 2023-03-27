//
//  WelcomeInteractor.swift
//  QuizPlease
//
//  Created by Владислав on 28.03.2023.
//  Copyright © 2023 Владислав. All rights reserved.
//

import Foundation

/// Welcome Screen interactor protocol
protocol WelcomeInteractorProtocol {

    /// Save a flag that welcome screen was presented to user
    func setWelcomeScreenWasPresented()

    /// Fetch client settings for default city
    func fetchClientSettings()
}

/// Welcome Screen interactor output protocol
protocol WelcomeInteractorOutput: AnyObject {

    /// Tells the delegate that client settings were loaded successfully
    func didFetchClientSettings()

    /// Tells the delegate that client settings were not loaded successfully
    func failedToFetchClientSettings(error: Error)
}

/// Welcome Screen interactor
final class WelcomeInteractor {

    weak var output: WelcomeInteractorOutput?

    // MARK: - Private Properties

    private let defaultsManager: DefaultsManager
    private let utilities: Utilities

    // MARK: - Lifecycle

    /// Initializer
    init(
        defaultsManager: DefaultsManager = .shared,
        utilities: Utilities = .main
    ) {
        self.defaultsManager = defaultsManager
        self.utilities = utilities
    }
}

// MARK: - WelcomeInteractorProtocol

extension WelcomeInteractor: WelcomeInteractorProtocol {

    func setWelcomeScreenWasPresented() {
        defaultsManager.setWelcomeScreenWasPresented()
    }

    func fetchClientSettings() {
        utilities.fetchClientSettings { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                self.output?.didFetchClientSettings()
            case let .failure(error):
                self.output?.failedToFetchClientSettings(error: error)
            }
        }
    }
}
