//
//  SpecialCondition.swift
//  QuizPlease
//
//  Created by Владислав on 17.06.2021.
//  Copyright © 2021 Владислав. All rights reserved.
//

final class SpecialCondition {
    var value: String?
    var discountInfo: DiscountInfo?
}

extension SpecialCondition {
    enum Kind: String, Decodable {
        case promocode = "promo", certificate
    }

    struct DiscountInfo {
        let kind: Kind?
        let discount: DiscountKind?
    }

    struct Response: Decodable {
        let success: Bool
        let message: String
        private let type: SpecialCondition.Kind?
        private let promo_type: Int?
        private let percent: Double?
        private let certificate_type: Int?
    }
}

extension SpecialCondition.Response {
    private var discountKind: DiscountKind? {
        if let certType = certificate_type,
           let certDiscount = CertificateDiscountType(rawValue: certType) {
            return .certificateDiscount(type: certDiscount)
        }
        if let promoType = promo_type {
            return .somePeopleForFree(amount: promoType)
        }
        if let fraction = percent {
            return .percent(fraction: fraction)
        }
        return nil
    }

    var discountInfo: SpecialCondition.DiscountInfo {
        return SpecialCondition.DiscountInfo(kind: type, discount: discountKind)
    }
}
