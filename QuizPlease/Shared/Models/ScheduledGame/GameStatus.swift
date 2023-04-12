//
//  GameStatus.swift
//  QuizPlease
//
//  Created by Владислав on 06.10.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import UIKit

/// Status of the game
enum GameStatus: Int, Decodable {

    case placesAvailable = 1,
         reserveAvailable = 2,
         noPlaces = 3,
         invite = 4,
         ended = 6

    /// A special status that comes from the backend in a separate field
    case fewPlaces = 100

    /// String representation of `rawValue`
    var identifier: String {
        "\(rawValue)"
    }

    var comment: String {
        switch self {
        case .placesAvailable:
            return "Есть места"
        case .reserveAvailable:
            return "Нет мест! Но можно записаться в резерв"
        case .noPlaces:
            return "Нет мест! Резерв заполнен"
        case .invite:
            return "Только по приглашениям"
        case .ended:
            return "Закончилась"
        case .fewPlaces:
            return "Осталось мало мест"
        }
    }

    var buttonTitle: String {
        switch self {
        case .placesAvailable, .fewPlaces:
            return "Записаться на игру"
        case .reserveAvailable:
            return "Записаться в резерв"
        default:
            return "Запись закрыта"
        }
    }

    var accentColor: UIColor {
        switch self {
        case .placesAvailable, .fewPlaces:
            return .lightGreen
        case .reserveAvailable:
            return .lemon
        case .invite, .ended, .noPlaces:
            return .themeGray
        }
    }

    var imageName: String {
        switch self {
        case .placesAvailable:
            return "tick"
        case .reserveAvailable:
            return "soldOut"
        case .fewPlaces:
            return "fire"
        default:
            return "lock"
        }
    }

    var image: UIImage? {
        UIImage(named: imageName)
    }

    var isRegistrationAvailable: Bool {
        switch self {
        case .placesAvailable, .reserveAvailable, .fewPlaces:
            return true
        default:
            return false
        }
    }
}
