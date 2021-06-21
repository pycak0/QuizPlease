//
//  SpecialCondition.swift
//  QuizPlease
//
//  Created by Владислав on 17.06.2021.
//  Copyright © 2021 Владислав. All rights reserved.
//

struct SpecialCondition {
    var value: String?
    var discountInfo: SpecialConditionDiscountInfo?
}

struct SpecialConditionDiscountInfo {
    let kind: SpecialConditionKind?
    let discount: DiscountKind
}

enum DiscountKind {
    case percent(fraction: Double)
    case somePeopleForFree(amount: Int)
    case certificateDiscount(type: CertificateDiscountType)
    case none
}
