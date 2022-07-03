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
        URL(string: "https://docs.google.com/document/d/1r5YlaJF5PEgPRrNn0SmrnqHNyzmD_PiM")!
    }()

    public static var isDebug: Bool {
        #if DEBUG
        return true
        #else
        return false
        #endif
    }

    public static var description: String {
        """
        AppSettings: {
            userToken: "\(userToken ?? "nil")"
            defaultCity: \(defaultCity)
            isShopEnabled: \(isShopEnabled)
            isProfileEnabled: \(isProfileEnabled)
            isDebug: \(isDebug)
        }
        """
    }
}
