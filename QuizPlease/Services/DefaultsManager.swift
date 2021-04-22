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
    private let fcmTokenKey = "fcm-token-key"
    private let answeredQuestionsKey = "answered-questions-key"
    private let clientSettingsKey = "client-settings"
    
    //MARK:- Auth Info
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
    
    func removeAuthInfo() {
        defaults.removeObject(forKey: authInfoKey)
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
    
    //MARK:- FCM Token
    func getFcmToken() -> String? {
        defaults.string(forKey: fcmTokenKey)
    }
    
    func saveFcmToken(_ token: String) {
        defaults.setValue(token, forKey: fcmTokenKey)
    }
    
    //MARK:- Answered Questions
    func saveAnsweredQuestionId(_ id: String) {
        var array = getSavedQuestionIds() ?? []
        array.append(id)
        defaults.set(array, forKey: answeredQuestionsKey)
    }
    
    func getSavedQuestionIds() -> [String]? {
        defaults.stringArray(forKey: answeredQuestionsKey)
    }
    
    func removeSavedWarmupQuestion(with id: String) {
        var array = getSavedQuestionIds() ?? []
        array.removeAll(where: { $0 == id })
        defaults.set(array, forKey: answeredQuestionsKey)
    }
    
    func removeAllSavedWarmupQuestions() {
        defaults.removeObject(forKey: answeredQuestionsKey)
    }
    
    //MARK:- Client Settings
    func saveClientSettings(_ settings: ClientSettings) {
        do {
            let data = try JSONEncoder().encode(settings)
            defaults.set(data, forKey: clientSettingsKey)
        } catch {
            print(error)
        }
    }
    
    func getClientSettings() -> ClientSettings? {
        if let data = defaults.data(forKey: clientSettingsKey),
           let settings = try? JSONDecoder().decode(ClientSettings.self, from: data) {
            return settings
        }
        return nil
    }
    
    func removeClientSettings() {
        defaults.removeObject(forKey: clientSettingsKey)
    }
}
