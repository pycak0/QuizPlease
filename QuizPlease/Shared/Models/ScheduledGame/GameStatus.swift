//
//  GameStatus.swift
//  QuizPlease
//
//  Created by Владислав on 06.10.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import UIKit

enum GameStatus: Int, Decodable {
    case placesAvailable = 1, reserveAvailable = 2, noPlaces = 3, invite = 4, ended = 6

    case fewPlaces = 100

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

    var image: UIImage? {
        switch self {
        case .placesAvailable:
            return UIImage(named: "tick")
        case .reserveAvailable:
            return UIImage(named: "soldOut")
        case .fewPlaces:
            return UIImage(named: "fire")
        default:
            return UIImage(named: "lock")
        }
    }
}
