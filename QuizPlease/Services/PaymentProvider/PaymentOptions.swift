//
//  PaymentOptions.swift
//  QuizPlease
//
//  Created by Владислав on 09.07.2021.
//  Copyright © 2021 Владислав. All rights reserved.
//

struct PaymentOptions {
    let amount: Double
    let shopName: String
    let description: String
    let userPhoneNumber: String?
    
    init(amount: Double, shopName: String = "Квиз, плиз!", description: String, userPhoneNumber: String?) {
        self.shopName = shopName
        self.amount = amount
        self.description = description
        self.userPhoneNumber = userPhoneNumber
    }
}
