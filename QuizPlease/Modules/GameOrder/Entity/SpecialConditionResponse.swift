//
//  SpecialConditionResponse.swift
//  QuizPlease
//
//  Created by Владислав on 18.06.2021.
//  Copyright © 2021 Владислав. All rights reserved.
//

import Foundation

enum SpecialConditionKind: String, Decodable {
    case promocode = "promo", certificate
}

struct SpecialConditionResponse: Decodable {
    let success: Bool
    let message: String
    private let type: SpecialConditionKind?
    private let promo_type: Int?
    private let percent: Double?
    private let certificate_type: Int?
}

extension SpecialConditionResponse {
    private var discountKind: DiscountKind {
        if let certType = certificate_type {
            return .certificateDiscount(type: CertificateDiscountType(rawValue: certType))
        }
        if let promoType = promo_type {
            return .somePeopleForFree(amount: promoType)
        }
        if let fraction = percent {
            return .percent(fraction: fraction)
        }
        return .none
    }
    
    var discountInfo: SpecialConditionDiscountInfo {
        return SpecialConditionDiscountInfo(kind: type, discount: discountKind)
    }
}
