//
//  SchedulePlace.swift
//  QuizPlease
//
//  Created by Владислав on 03.09.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import Foundation

struct SchedulePlace: ScheduleFilterProtocol {
    static let apiName = "places"
    
    var id: Int
    var title: String
    var address: String
}
