//
//  ShopPurchaseRequest.swift
//  QuizPlease
//
//  Created by Русаков Владислав Андреевич on 28.01.2026.
//  Copyright © 2026 Владислав. All rights reserved.
//


import UIKit

struct ShopPurchaseRequest: Encodable {
    let productId: Int
    let deliveryMethod: Int
    let cityId: Int
    let email: String
    let isPersonalDataConsent: Bool
    let isMarketingConsent: Bool

    enum CodingKeys: String, CodingKey {
        case productId = "product_id"
        case deliveryMethod = "delivery_method"
        case cityId = "city_id"
        case email
        case isPersonalDataConsent = "is_personal_data_consent"
        case isMarketingConsent = "is_marketing_consent"
    }
}
