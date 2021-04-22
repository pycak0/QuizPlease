//
//  SplashScreenInteractor.swift
//  QuizPlease
//
//  Created by Владислав on 12.04.2021.
//  Copyright © 2021 Владислав. All rights reserved.
//

import Foundation

protocol SplashScreenInteractorProtocol {
    ///must be weak
    var interactorOutput: SplashScreenInteractorOutput? { get }
    
    ///Uses app default city to load settings, updates `AppSettings` and saves new `ClientSettings` to the UserDefaults
    func updateClientSettings()
    
    func updateDefaultCity()
    
    func updateToken()
}

protocol SplashScreenInteractorOutput: class {
    func interactor(_ interactor: SplashScreenInteractorProtocol, errorOccured error: SessionError)
    func interactor(_ interactor: SplashScreenInteractorProtocol, didLoadClientSettings settings: ClientSettings)
    func interactorDidUpdateUserToken(_ interactor: SplashScreenInteractorProtocol)
}

class SplashScreenInteractor: SplashScreenInteractorProtocol {
    weak var interactorOutput: SplashScreenInteractorOutput?
    
    func updateDefaultCity() {
        Utilities.main.setDefaultCityFromCache()
    }
    
    func updateToken() {
        Utilities.main.updateToken {
            self.interactorOutput?.interactorDidUpdateUserToken(self)
        }
    }
    
    func updateClientSettings() {
        Utilities.main.setClientSettingsFromCache()
        Utilities.main.fetchClientSettings { [weak self] (newSettings, error) in
            guard let self = self else { return }
            if let error = error {
                self.interactorOutput?.interactor(self, errorOccured: error)
                return
            }
            guard let settings = newSettings else {
                let error = SessionError.other(NSError(domain: "Unknown", code: -1))
                self.interactorOutput?.interactor(self, errorOccured: error)
                return
            }
            self.interactorOutput?.interactor(self, didLoadClientSettings: settings)
        }
    }
}
