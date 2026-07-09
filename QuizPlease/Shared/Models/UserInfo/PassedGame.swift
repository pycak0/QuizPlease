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

struct SignedUpGame: Decodable {

    private struct Place: Decodable {
        let title: String?
    }

    let id: String
    private let place: Place?
    private let date: String?
    let title: String
    private let game_number: String
    private let team_name: String?
    private let status: Int?

    var gameNumber: String {
        game_number.hasPrefix("#") ? game_number : "#\(game_number)"
    }

    var placeTitle: String? {
        place?.title
    }

    var teamName: String? {
        guard let teamName = team_name?.trimmingCharacters(in: .whitespacesAndNewlines), !teamName.isEmpty
        else { return nil }
        return teamName
    }

    var isFinished: Bool {
        status == 4 || status == 5
    }

    var dateAndTime: String? {
        guard let date, let value = Self.isoDateFormatter.date(from: date) else { return nil }
        return Self.displayDateFormatter.string(from: value)
    }

    private static let isoDateFormatter: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return formatter
    }()

    private static let displayDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.dateFormat = "d MMMM, HH:mm"
        return formatter
    }()
}
