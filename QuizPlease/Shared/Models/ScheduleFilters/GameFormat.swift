//
//  GameFormat.swift
//  QuizPlease
//
//  Created by Владислав on 03.09.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import Foundation

enum GameFormat: Int, Decodable, CaseIterable, ScheduleFilterProtocol {
    case offline, online

    /// Do not assign to this case. It is used for system purposes
    case all

    var id: Int { rawValue }

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
