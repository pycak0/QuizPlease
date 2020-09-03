//
//  GameFormat.swift
//  QuizPlease
//
//  Created by Владислав on 03.09.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import Foundation

enum GameFormat: Int, Decodable, ScheduleFilterProtocol, CaseIterable {
    static let apiName = "format"
    
    case offline, online, all
    
    var title: String {
        switch self {
        case .all:
            return "Все форматы"
        case .online:
            return "Онлайн"
        case .offline:
            return "Офлайн"
        }
    }
}
