//
//  Place.swift
//  QuizPlease
//
//  Created by Владислав on 13.08.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import Foundation

struct Place: Decodable {
    var name: String
    var address: String
    var longitude: Double
    var latitude: Double
}
