//
//  PaymentDetails.swift
//  QuizPlease
//
//  Created by Владислав on 24.08.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import Foundation

enum PaymentType {
    case online, cash
}

struct PaymentDetails {
    var numberOfPeople: Int
    var sum: Decimal
}
