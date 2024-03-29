//
//  PassedGame.swift
//  QuizPlease
//
//  Created by Владислав on 09.10.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import Foundation

struct PassedGame: Decodable {
    let id: String
    private let name: String
    let title: String
    let place: String?

    private var bonus_points: Double?

    init(sampleTitle: String) {
        id = "-1"
        name = "1"
        title = sampleTitle
        place = "sample place"
    }
}

extension PassedGame {
    var gameNumber: String {
        let number = name.trimmingCharacters(in: .whitespaces)
        if number.hasPrefix("#") {
            return number
        }
        return "#\(number)"
    }

    var points: Double? { bonus_points }
}
