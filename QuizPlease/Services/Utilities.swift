//
//  Utilities.swift
//  QuizPlease
//
//  Created by Владислав on 09.10.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import Foundation

final class Utilities {
    private init() {}

    static let main = Utilities()

    func setDefaultCityFromCache() {
        if let city = DefaultsManager.shared.getDefaultCity() {
            AppSettings.defaultCity = city
        }
    }

    func setClientSettingsFromCache() {
        if let settings = DefaultsManager.shared.getClientSettings() {
            AppSettings.isShopEnabled = settings.isShopEnabled
            AppSettings.isProfileEnabled = settings.isProfileEnabled
        }
    }

    func fetchClientSettings(completion: ((Result<ClientSettings, NetworkServiceError>) -> Void)? = nil) {
        NetworkService.shared.getSettings(cityId: AppSettings.defaultCity.id) { (result) in
            switch result {
            case let .failure(error):
                print(error)
                completion?(.failure(error))
            case let .success(settings):
                AppSettings.isShopEnabled = settings.isShopEnabled
                AppSettings.isProfileEnabled = settings.isProfileEnabled
                DefaultsManager.shared.saveClientSettings(settings)
                completion?(.success(settings))
            }
        }
    }
}
