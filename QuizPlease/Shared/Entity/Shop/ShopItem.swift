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
}

extension ShopItem {
    var image: UIImage? {
//        if price > 0 {
//            return UIImage(named: "logoSmall")?.withRenderingMode(.alwaysOriginal)
//        }
        return UIImage(named: "logoSmall")?.withRenderingMode(.alwaysOriginal)
    }
    
    var priceNumber: Int {
        Int(Double(price) ?? 99999)
    }
}
