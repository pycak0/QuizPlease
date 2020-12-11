//
//  GameStatus.swift
//  QuizPlease
//
//  Created by Владислав on 06.10.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import Foundation

enum GameStatus: Int, Decodable {
    case placesAvailable = 1, reserveAvailable = 2, noPlaces = 3, invite = 4, ended = 6
    
    var comment: String {
        switch self {
        case .placesAvailable:
            return "Есть места"
        case .reserveAvailable:
            return "Нет мест! Но можно записаться в резерв"
        case .noPlaces:
            return "Совсем нет мест :("
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
}
