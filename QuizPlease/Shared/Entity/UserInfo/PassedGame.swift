//
//  PassedGame.swift
//  QuizPlease
//
//  Created by Владислав on 09.10.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import Foundation

struct PassedGame: Decodable {
    var id: String
    private var name: String
    var title: String
    var place: String?
    
    private var bonus_points: AnyValue?
    
    init(sampleTitle: String) {
        id = "-1"
        name = "1"
        title = sampleTitle
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
    
    var points: Int? {
        if let points = bonus_points?.value() as? Int {
            return points
        }
        if let pointsStr = bonus_points?.value() as? String {
            return Int(pointsStr)
        }
        return nil
    }
}
