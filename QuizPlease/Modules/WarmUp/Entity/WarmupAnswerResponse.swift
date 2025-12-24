//
//  WarmupAnswerResponse.swift
//  QuizPlease
//
//  Created by Владислав on 30.04.2021.
//  Copyright © 2021 Владислав. All rights reserved.
//

import Foundation

struct WarmupAnswerResponse: Decodable {
    let message: String
    private let result: Bool?

    var isCorrect: Bool {
        result ?? false
    }

    init(message: String, result: Bool) {
        self.message = message
        self.result = result
    }
}
