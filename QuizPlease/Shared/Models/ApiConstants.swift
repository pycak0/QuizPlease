//
//  ApiConstants.swift
//  QuizPlease
//
//  Created by Русаков Владислав Андреевич on 17.11.2025.
//  Copyright © 2025 Владислав. All rights reserved.
//

enum ApiConstants {

    enum Path {
        // Users
        static let currentUser = "/api/users/current"
        static let setUserCity = "/api/users/set-city"

        // Settings
        static let settings = "/api/settings"

        // City
        static let city = "/api/city"

        // Rating
        static let rating = "/api/rating"

        // Shop / Products / Orders
        static let product = "/api/product"
        static let orderBuy = "/api/order/buy"

        // Home game
        static let homeGame = "/api/home-game"
        static func homeGame(id: Int) -> String { "/api/home-game/\(id)" }

        // Game
        static let game = "/api/game"
        static func gameFilter(_ typeRawValue: String) -> String { "/api/game/\(typeRawValue)" }
        static let gameSubscribeNotification = "/api/game/subscribe-notification"
        static let gameCheckQR = "/api/game/check-qr"

        // Auth
        static let authRegister = "/api/auth/register"
        static let authToken = "/api/auth/token"

        // Device
        static let deviceCreate = "/api/device/create"

        // Ajax
        static let ajaxScopeGame = "/ajax/scope-game"
        static let ajaxSaveRecord = "/ajax/save-record"
        static let ajaxCheckCode = "/ajax/check-code"
        static let ajaxIsRecordNameExist = "/ajax/is-record-name-exist"

        // Warmup
        static let warmupQuestion = "/api/warmup-question"
        static let warmupSendAnswer = "/api/warmup-question/send-answer"
    }
}

