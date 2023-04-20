//
//  MainMenuInteractor.swift
//  QuizPlease
//
//  Created by Владислав on 03.08.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import Foundation
import UserNotifications

protocol MainMenuInteractorProtocol: AnyObject {
    /// must be weak
    var output: MainMenuInteractorOutput? { get }

    func postMainScreenLoaded()
    func requestForPushNotifications()

    func loadMenuItems()
    func loadUserInfo()
    func loadShopItems()

    /// Loads new client settings, then calls `loadMenuItems`, `loadShopItems` and `loadUserInfo`
    func updateAllData()
}

protocol MainMenuInteractorOutput: AnyObject {
    func interactor(_ interactor: MainMenuInteractorProtocol, didLoadMenuItems: [MainMenuItemProtocol])
    func interactor(_ interactor: MainMenuInteractorProtocol, didLoadUserInfo userInfo: UserInfo)
    func interactor(_ interactor: MainMenuInteractorProtocol, didLoadShopItems: [ShopItem])
    func interactor(_ interactor: MainMenuInteractorProtocol, failedToLoadShopItemsWithError error: NetworkServiceError)
    func interactor(_ interactor: MainMenuInteractorProtocol, failedToLoadMenuItemsWithError error: NetworkServiceError)
    func interactor(_ interactor: MainMenuInteractorProtocol, failedToLoadUserInfoWithError error: NetworkServiceError)
}

class MainMenuInteractor: MainMenuInteractorProtocol {
    weak var output: MainMenuInteractorOutput?

    func postMainScreenLoaded() {
        NotificationCenter.default.post(name: .mainScreenLoaded, object: nil)
    }

    func requestForPushNotifications() {
        UNUserNotificationCenter.current().requestAuthorization(
            options: [.alert, .badge, .sound],
            completionHandler: {_, _ in }
        )
    }

    func loadMenuItems() {
        var items = MainMenuItemKind.allCases

        if !AppSettings.isProfileEnabled {
            items.removeAll(where: { $0._kind == .profile })
        }
        if !AppSettings.isShopEnabled {
            items.removeAll(where: { $0._kind == .shop })
        }
        output?.interactor(self, didLoadMenuItems: items)
        // completion(.success(items))
    }

    func loadUserInfo() {
        NetworkService.shared.getUserInfo { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .failure(error):
                self.output?.interactor(self, failedToLoadUserInfoWithError: error)
            case let .success(userInfo):
                self.output?.interactor(self, didLoadUserInfo: userInfo)
            }
        }
    }

    func loadShopItems() {
        // completion(self.createSampleItems())
        NetworkService.shared.getShopItems { [weak self] (serverResult) in
            guard let self = self else { return }
            switch serverResult {
            case let .failure(error):
                self.output?.interactor(self, failedToLoadShopItemsWithError: error)
            case let .success(items):
                let shopItems = Array(items.prefix(3))
                self.output?.interactor(self, didLoadShopItems: shopItems)
            }
        }
    }

    func updateAllData() {
        Utilities.main.fetchClientSettings { _ in
            self.loadMenuItems()
            self.loadShopItems()
            self.loadUserInfo()
        }
    }
}
