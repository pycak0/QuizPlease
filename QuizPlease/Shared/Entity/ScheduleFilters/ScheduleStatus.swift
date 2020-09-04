//
//  ScheduleStatus.swift
//  QuizPlease
//
//  Created by Владислав on 03.09.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import Foundation

struct ScheduleStatus: ScheduleFilterProtocol {
    static let apiName: String = "statuses"
        
    var id: Int
    var title: String
}
