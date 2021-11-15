//
//  PaymentOptions.swift
//  QuizPlease
//
//  Created by Владислав on 09.07.2021.
//  Copyright © 2021 Владислав. All rights reserved.
//

struct PaymentOptions {

     let amount: Double
     let description: String
     let userPhoneNumber: String?
     let shopId: String
     let shopName: String
     let transactionKey: String

     init(
         amount: Double,
         description: String,
         shopId: String,
         transactionKey: String,
         userPhoneNumber: String?,
         shopName: String = "Квиз, плиз!"
     ) {
         self.amount = amount
         self.description = description
         self.userPhoneNumber = userPhoneNumber
         self.shopName = shopName
         self.shopId = shopId
         self.transactionKey = transactionKey
     }
}
