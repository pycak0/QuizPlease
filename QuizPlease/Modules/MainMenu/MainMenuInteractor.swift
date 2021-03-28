//
//  MainMenuInteractor.swift
//  QuizPlease
//
//  Created by Владислав on 03.08.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import Foundation

protocol MainMenuInteractorProtocol: class {
    func loadMenuItems(completion: @escaping (Result<[MenuItemProtocol]?, Error>) -> Void)
    
    func loadUserInfo(completion: @escaping ((Result<UserInfo, SessionError>) -> Void))
    
    func loadShopItems(completion: @escaping ([ShopItem]) -> Void)
    
//    func createSampleItems() -> [ShopItem]
}

class MainMenuInteractor: MainMenuInteractorProtocol {
    func loadMenuItems(completion: @escaping (Result<[MenuItemProtocol]?, Error>) -> Void) {
        var items: [MenuItemProtocol] = []
        for i in 0..<MenuItemKind.allCases.count {
            let kind = MenuItemKind(rawValue: i)!
            items.append(MenuItem(kind))
        }
        
        completion(.success(items))
    }
    
    func loadUserInfo(completion: @escaping ((Result<UserInfo, SessionError>) -> Void)) {
        NetworkService.shared.getUserInfo(completion: completion)
    }
    
    func loadShopItems(completion: @escaping ([ShopItem]) -> Void) {
        //completion(self.createSampleItems())
        NetworkService.shared.getShopItems { [weak self] (serverResult) in
            guard let self = self else { return }
            switch serverResult {
            case let .failure(error):
                print(error)
                completion([])
//                completion(self.createSampleItems())
            case let .success(items):
//                if items.count > 0 {
                    completion(Array(items.prefix(3)))
//                }
            }
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
