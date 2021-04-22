//
//  City.swift
//  QuizPlease
//
//  Created by Владислав on 27.08.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import Foundation

struct City: Codable {
    var id: Int
    var title: String
}

extension City {
    static let moscow = City(id: 9, title: "Москва")
}
