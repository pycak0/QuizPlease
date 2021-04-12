//
//  AppSettings.swift
//  QuizPlease
//
//  Created by Владислав on 27.08.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import Foundation

enum AppSettings {
    static var userToken: String? {
        didSet {
            //guard let token = userToken else { return }
            //DefaultsManager.shared.saveUserToken(token)
        }
    }
    
    static var defaultCity: City = City(id: 9, title: "Москва") {
        didSet {
            DefaultsManager.shared.saveDefaultCity(defaultCity)
        }
    }
}
