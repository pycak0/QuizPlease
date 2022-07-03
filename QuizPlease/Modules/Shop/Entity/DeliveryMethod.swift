//
//  DeliveryMethod.swift
//  QuizPlease
//
//  Created by Владислав on 11.10.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import Foundation

enum DeliveryMethod {
    case game, online

    init?(title: String) {
        switch title {
        case DeliveryMethod.game.title:
            self = .game
        case DeliveryMethod.online.title:
            self = .online
        default:
            return nil
        }
    }

    /// An identificator of DeliveryMethod used to perform server request
    var id: Int {
        switch self {
        case .online:
            return 2
        case .game:
            return 1
        }
    }

    var title: String {
        switch self {
        case .online:
            return "Получить на e-mail"
        case .game:
            return "Забрать на игре"
        }
    }

    /// A message to show to user after successful purchase request
    var message: String {
        return "Наш менеджер отправит информацию о заказе на указанную почту"
    }
}
