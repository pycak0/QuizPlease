//
//  AppSettings.swift
//  QuizPlease
//
//  Created by Владислав on 27.08.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import Foundation

public enum AppSettings {
    public static var userToken: String? {
        didSet {
            // guard let token = userToken else { return }
            // DefaultsManager.shared.saveUserToken(token)
        }
    }

    public static var defaultCity: City = .moscow {
        didSet {
            if DefaultsManager.shared.getDefaultCity() != defaultCity {
                DefaultsManager.shared.saveDefaultCity(defaultCity)
                NetworkService.shared.setDefaultCity(defaultCity)
            }
            // Utilities.main.fetchClientSettings()
        }
    }

    public static var isShopEnabled: Bool = false
    public static var isProfileEnabled: Bool = false

    public static let termsOfUseUrl: URL = {
        URL(string: "https://quizplease.ru/rules")!
    }()

    public static let privacyPolicyUrl: URL = {
        URL(string: "https://quizplease.ru/agreement")!
    }()

    /// App's URL on the App Store
    public static let appStoreUrl: URL = {
        URL(string: "https://apps.apple.com/ru/app/id1585713090")!
    }()

    /// Whether the new GamePage is enabled or not
    public static var isGamePageEnabled = true

    public static var geoChecksAlwaysSuccessful = false

    /// Enable in-app payment only for online games
    public static var inAppPaymentOnlyForOnlineGamesEnabled = true

    public static var description: String {
        """
        AppSettings: {
            userToken: "\(userToken ?? "nil")"
            defaultCity: \(defaultCity)
            isShopEnabled: \(isShopEnabled)
            isProfileEnabled: \(isProfileEnabled)
            configuration: \(Configuration.current)
        }
        """
    }
}
