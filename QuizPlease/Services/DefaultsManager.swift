//
//  DefaultsManager.swift
//  QuizPlease
//
//  Created by Владислав on 08.10.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import Foundation

final class DefaultsManager {
    // singleton
    private init() {}

    static let shared = DefaultsManager()

    private let defaults = UserDefaults.standard
    private let decoder = JSONDecoder()
    private let encoder = JSONEncoder()

    private let userTokenKey = "user-token"
    private let authInfoKey = "user-auth-info"
    private let defaultCityKey = "default-city"
    private let userInfoKey = "user-saved-info"
    private let fcmTokenKey = "fcm-token-key"
    private let answeredQuestionsKey = "answered-questions-key"
    private let clientSettingsKey = "client-settings"
    private let profileOnboardingMarker = "profile.onboarding"
    private let welcomeScreenMarker = "welcome.screen.presented"
    private let versionInfoKey = "app.version.info"

    // MARK: - Auth Info
    func getUserAuthInfo() -> SavedAuthInfo? {
        if let data = defaults.data(forKey: authInfoKey),
           let authInfo = try? decoder.decode(SavedAuthInfo.self, from: data) {
            return authInfo
        }
        return nil
    }

    func saveAuthInfo(_ info: SavedAuthInfo) {
        do {
            let data = try encoder.encode(info)
            defaults.setValue(data, forKey: authInfoKey)
        } catch {
            print(error)
        }
    }

    func removeAuthInfo() {
        defaults.removeObject(forKey: authInfoKey)
    }

    // MARK: - Default City 
    func getDefaultCity() -> City? {
        if let data = defaults.data(forKey: defaultCityKey),
           let city = try? decoder.decode(City.self, from: data) {
            return city
        }
        return nil
    }

    func saveDefaultCity(_ city: City) {
        do {
            let data = try encoder.encode(city)
            defaults.set(data, forKey: defaultCityKey)
        } catch {
            print(error)
        }
    }

    // MARK: - FCM Token
    func getFcmToken() -> String? {
        defaults.string(forKey: fcmTokenKey)
    }

    func saveFcmToken(_ token: String) {
        defaults.setValue(token, forKey: fcmTokenKey)
    }

    // MARK: - Answered Questions
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

    // MARK: - Client Settings
    func saveClientSettings(_ settings: ClientSettings) {
        do {
            let data = try encoder.encode(settings)
            defaults.set(data, forKey: clientSettingsKey)
        } catch {
            print(error)
        }
    }

    func getClientSettings() -> ClientSettings? {
        if let data = defaults.data(forKey: clientSettingsKey),
           let settings = try? decoder.decode(ClientSettings.self, from: data) {
            return settings
        }
        return nil
    }

    func removeClientSettings() {
        defaults.removeObject(forKey: clientSettingsKey)
    }

    // MARK: - Profile Onboarding

    func wasProfileOnboardingPresented() -> Bool {
        defaults.bool(forKey: profileOnboardingMarker)
    }

    func setProfileOnboardingWasPresented() {
        defaults.set(true, forKey: profileOnboardingMarker)
    }

    func wasWelcomeScreenPresented() -> Bool {
        defaults.bool(forKey: welcomeScreenMarker)
    }

    func setWelcomeScreenWasPresented() {
        defaults.set(true, forKey: welcomeScreenMarker)
    }

    // MARK: - Version Info

    func getVersionInfo() -> VersionInfoModel? {
        if let data = defaults.data(forKey: versionInfoKey),
           let authInfo = try? decoder.decode(VersionInfoModel.self, from: data) {
            return authInfo
        }
        return nil
    }

    func saveVersionInfo(_ info: VersionInfoModel) {
        do {
            let data = try encoder.encode(info)
            defaults.setValue(data, forKey: versionInfoKey)
        } catch {
            print(error)
        }
    }
}
