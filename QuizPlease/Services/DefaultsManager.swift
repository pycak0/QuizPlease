//
//  DefaultsManager.swift
//  QuizPlease
//
//  Created by Владислав on 08.10.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import Foundation

class DefaultsManager {
    //singleton
    private init() {}
    
    static let shared = DefaultsManager()
    
    private let defaults = UserDefaults.standard
    private let userTokenKey = "user-token"
    private let authInfoKey = "user-auth-info"
    private let defaultCityKey = "default-city"
    private let userInfoKey = "user-saved-info"
    
    //MARK:- Auth Info
//    func getUserToken() -> String? {
//        return defaults.string(forKey: userTokenKey)
//    }
//    
//    func saveUserToken(_ token: String) {
//        defaults.set(token, forKey: userTokenKey)
//    }
    
    func getUserAuthInfo() -> SavedAuthInfo? {
        if let data = defaults.data(forKey: authInfoKey),
           let authInfo = try? JSONDecoder().decode(SavedAuthInfo.self, from: data) {
            return authInfo
        }
        return nil
    }
    
    func saveAuthInfo(_ info: SavedAuthInfo) {
        do {
            let data = try JSONEncoder().encode(info)
            defaults.setValue(data, forKey: authInfoKey)
        } catch {
            print(error)
        }
    }
    
    //MARK:- Default City 
    func getDefaultCity() -> City? {
        if let data = defaults.data(forKey: defaultCityKey),
           let city = try? JSONDecoder().decode(City.self, from: data) {
            return city
        }
        return nil
    }
    
    func saveDefaultCity(_ city: City) {
        do {
            let data = try JSONEncoder().encode(city)
            defaults.set(data, forKey: defaultCityKey)
        } catch {
            print(error)
        }
    }
}
