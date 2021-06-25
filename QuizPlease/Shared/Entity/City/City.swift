//
//  City.swift
//  QuizPlease
//
//  Created by Владислав on 27.08.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import Foundation

public struct City: Codable {
    public let id: Int
    public let title: String
}

extension City {
    public static let moscow = City(id: 9, title: "Москва")
}

extension City: Equatable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.id == rhs.id
    }
}
