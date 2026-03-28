//
//  PaymentType.swift
//  QuizPlease
//
//  Created by Владислав on 24.08.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import Foundation

enum PaymentType: Int, CaseIterable, Encodable {

    /// In-app Payment
    case online = 1

    /// Payment type not available in app
    case cash
}

// MARK: - PaymentType + Name

extension PaymentType {

    var name: String {
        switch self {
        case .online:
            return "Онлайн\nоплата"
        case .cash:
            return "Оплата\nна игре"
        }
    }

    init?(name: String) {
        for type in [PaymentType.online, .cash] where name == type.name {
            self = type
            return
        }
        return nil
    }
}
