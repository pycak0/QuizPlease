//
//  ShopItem.swift
//  QuizPlease
//
//  Created by Владислав on 20.08.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import UIKit

struct ShopItem: Decodable {
    var id: Int?
    var title: String
    var description: String
    private var price: Double
    private var images: [ShopItemImage]?
    
    init(title: String, description: String, price: Double) {
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
        Int(price)
        //Int(Double(price) ?? 99999)
    }
}
