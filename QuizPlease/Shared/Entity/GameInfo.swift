//
//MARK:  GameInfo.swift
//  QuizPlease
//
//  Created by Владислав on 09.08.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import Foundation

struct GameInfo: Decodable {
    var gameNumber: Int
    var name: String
    var place: Place
    var time: String
    var price: Decimal
    var annotation: String
}
