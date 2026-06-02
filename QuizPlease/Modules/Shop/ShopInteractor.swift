//
//  ShopInteractor.swift
//  QuizPlease
//
//  Created by Владислав on 05.08.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import UIKit

protocol ShopInteractorProtocol {
    func loadItems(completion: @escaping (Result<[ShopItem], NetworkServiceError>) -> Void)

    func loadUserInfo(completion: @escaping ((Result<UserInfo, NetworkServiceError>) -> Void))
}

class ShopInteractor: ShopInteractorProtocol {

    private let userService: UserService

    init(userService: UserService) {
        self.userService = userService
    }

    func loadItems(completion: @escaping (Result<[ShopItem], NetworkServiceError>) -> Void) {
        NetworkService.shared.getShopItems(completion: completion)
    }

    func loadUserInfo(completion: @escaping ((Result<UserInfo, NetworkServiceError>) -> Void)) {
        userService.getUserInfo(completion: completion)
    }
}
