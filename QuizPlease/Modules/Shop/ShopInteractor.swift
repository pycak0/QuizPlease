//
//  ShopInteractor.swift
//  QuizPlease
//
//  Created by Владислав on 05.08.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import UIKit

protocol ShopInteractorProtocol {
    func loadItems(completion: @escaping (Result<[ShopItem], Error>) -> Void)
}

class ShopInteractor: ShopInteractorProtocol {
    func loadItems(completion: @escaping (Result<[ShopItem], Error>) -> Void) {
        var items = [ShopItem]()
        for i in 1...5 {
            items.append(
                ShopItem(id: "\(i)", name: "item\(i)", description: "Description\(i)", price: 10 * i, image: UIImage(named: "logoSmall")?.withRenderingMode(.alwaysOriginal))
            )
        }
        completion(.success(items))
    }
}
