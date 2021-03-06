//
//  PaymentType.swift
//  QuizPlease
//
//  Created by Владислав on 24.08.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import Foundation

enum PaymentType: Int, CaseIterable, Encodable {
    case online = 1, cash
}
