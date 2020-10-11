//
//  ShopInteractor.swift
//  QuizPlease
//
//  Created by Владислав on 05.08.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import UIKit

protocol ShopInteractorProtocol {
    func loadItems(completion: @escaping (Result<[ShopItem], SessionError>) -> Void)
    
    func loadUserInfo(completion: @escaping ((Result<UserInfo, SessionError>) -> Void))
}

class ShopInteractor: ShopInteractorProtocol {
    func loadItems(completion: @escaping (Result<[ShopItem], SessionError>) -> Void) {
        NetworkService.shared.getShopItems { (serverResult) in
            completion(serverResult)
        }
    }
    
    func loadUserInfo(completion: @escaping ((Result<UserInfo, SessionError>) -> Void)) {
        NetworkService.shared.getUserInfo(completion: completion)
    }
}
