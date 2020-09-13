//
//  ScheduleFilter.swift
//  QuizPlease
//
//  Created by Владислав on 04.09.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import Foundation

struct ScheduleFilter {
    var city: City = Globals.defaultCity
    var date: ScheduleFilterOption?
    var format: GameFormat?
    var type: ScheduleFilterOption?
    var place: ScheduleFilterOption?
    var status: ScheduleFilterOption?
}
