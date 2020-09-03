//
//  ScheduleFilterProtocol.swift
//  QuizPlease
//
//  Created by Владислав on 03.09.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import Foundation

protocol ScheduleFilterProtocol: Decodable {
    static var apiName: String { get }
}
