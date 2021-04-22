//
//  MainMenuInteractor.swift
//  QuizPlease
//
//  Created by Владислав on 03.08.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import Foundation

protocol MainMenuInteractorProtocol: class {
    ///must be weak
    var output: MainMenuInteractorOutput? { get }
    
    func loadMenuItems()
    func loadUserInfo()
    func loadShopItems()
    
    ///Loads new client settings, then calls `loadMenuItems`, `loadShopItems` and `loadUserInfo`
    func updateAllData()
}

protocol MainMenuInteractorOutput: class {
    func interactor(_ interactor: MainMenuInteractorProtocol, didLoadMenuItems: [MenuItemProtocol])
    func interactor(_ interactor: MainMenuInteractorProtocol, didLoadUserInfo userInfo: UserInfo)
    func interactor(_ interactor: MainMenuInteractorProtocol, didLoadShopItems: [ShopItem])
    func interactor(_ interactor: MainMenuInteractorProtocol, failedToLoadShopItemsWithError error: SessionError)
    func interactor(_ interactor: MainMenuInteractorProtocol, failedToLoadMenuItemsWithError error: SessionError)
    func interactor(_ interactor: MainMenuInteractorProtocol, failedToLoadUserInfoWithError error: SessionError)
}

class MainMenuInteractor: MainMenuInteractorProtocol {
    weak var output: MainMenuInteractorOutput?
    
    func loadMenuItems() {
        var items = MenuItemKind.allCases
    
        if !AppSettings.isProfileEnabled {
            items.removeAll(where: { $0._kind == .profile })
        }
        if !AppSettings.isShopEnabled {
            items.removeAll(where: { $0._kind == .shop })
        }
        output?.interactor(self, didLoadMenuItems: items)
        //completion(.success(items))
    }
    
    func loadUserInfo() {
        NetworkService.shared.getUserInfo() { [weak self] result in
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
        //completion(self.createSampleItems())
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
        Utilities.main.fetchClientSettings { settings, error in
            self.loadMenuItems()
            self.loadShopItems()
            self.loadUserInfo()
        }
    }
    
    private func createSampleItems() -> [ShopItem] {
        var sampleItems = [ShopItem]()
        for i in 0..<3 {
            sampleItems.append(ShopItem(title: "SAMPLE", description: "SAMPLE", price: Double(1000 + 100 * i)))
        }
        return sampleItems
    }
}
