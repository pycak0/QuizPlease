//
//  City.swift
//  QuizPlease
//
//  Created by Владислав on 27.08.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import Foundation

public struct City: Codable {
    public var id: Int
    public var title: String
}

extension City {
    public static let moscow = City(id: 9, title: "Москва")
}
