//
//  ScheduledGamesResponse.swift
//  QuizPlease
//
//  Created by Владислав on 04.09.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import Foundation

struct ScheduledGamesResponse: Decodable {
    var data: [GameShortInfo]
}
