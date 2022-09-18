//
//  ShopItem.swift
//  QuizPlease
//
//  Created by Владислав on 20.08.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import UIKit

struct ShopItem: Decodable {

    let id: Int?
    let title: String
    let description: String
    private let price: Double
    private let images: [ShopItemImage]?
    private let offline_delivery: Int
    private let online_delivery: Int
}

extension ShopItem {

    var imagePath: String? {
        return images?.first?.path?.pathProof
    }

    var priceNumber: Int {
        Int(price)
        // Int(Double(price) ?? 99999)
    }

    var availableDeliveryMethods: [DeliveryMethod] {
        var methods = [DeliveryMethod]()
        if online_delivery == 1 {
            methods.append(.online)
        }
        if offline_delivery == 1 {
            methods.append(.game)
        }
        return methods
    }

    var isOfflineDeliveryOnly: Bool {
        availableDeliveryMethods.count == 1 && availableDeliveryMethods.first == .game
    }
}
