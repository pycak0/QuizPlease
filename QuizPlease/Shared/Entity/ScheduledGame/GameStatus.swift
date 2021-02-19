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
        }
    }
    
    var buttonTitle: String {
        switch self {
        case .placesAvailable:
            return "Записаться на игру"
        case .reserveAvailable:
            return "Записаться в резерв"
        default:
            return "Запись недоступна"
        }
    }
    
    var accentColor: UIColor {
        switch self {
        case .placesAvailable:
            return .lightGreen
        case .reserveAvailable:
            return .lemon
        case .noPlaces:
            return .themePink
        case .invite, .ended:
            return .lightGray
        }
    }
    
    var image: UIImage? {
        switch self {
        case .placesAvailable:
            return UIImage(named: "tick")
        case .reserveAvailable:
            return UIImage(named: "soldOut")
        default:
            return UIImage(named: "lock")
        }
    }
}
