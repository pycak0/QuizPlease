//
//  ScheduleFilterProtocol.swift
//  QuizPlease
//
//  Created by Владислав on 03.09.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import Foundation

protocol ScheduleFilterProtocol: Decodable {
    var id: Int { get }
    var title: String { get }
}
