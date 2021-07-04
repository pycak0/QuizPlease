//
//  DiscountKind.swift
//  QuizPlease
//
//  Created by Владислав on 26.06.2021.
//  Copyright © 2021 Владислав. All rights reserved.
//

import Foundation

enum DiscountKind {
    case percent(fraction: Double)
    case somePeopleForFree(amount: Int)
    case certificateDiscount(type: CertificateDiscountType)
    case none
}
