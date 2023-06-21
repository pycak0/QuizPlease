//
//  ScheduleFilter.swift
//  QuizPlease
//
//  Created by Владислав on 04.09.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import Foundation

struct ScheduleFilter {
    var city: City = AppSettings.defaultCity
    var date: ScheduleFilterOption?
    var format: ScheduleFilterOption?
    var type: ScheduleFilterOption?
    var place: ScheduleFilterOption?
    /// See `GameStatus` for possible options
    var status: ScheduleFilterOption?
}
