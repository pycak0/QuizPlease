//
//  ShopItem.swift
//  QuizPlease
//
//  Created by Владислав on 20.08.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import UIKit

struct ShopItem: Decodable {
    var id: String?
    var title: String
    var description: String
    private var price: String
    private var images: [ShopItemImage]?
    
    init(title: String, description: String, price: String) {
        self.title = title
        self.description = description
        self.price = price
    }
}

extension ShopItem {
    var imagePath: String? {
        return images?.first?.path?.pathProof
    }
    
    var priceNumber: Int {
        Int(Double(price) ?? 99999)
    }
}
