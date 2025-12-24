//
//  WarmupAnswerData.swift
//  QuizPlease
//
//  Created by Русаков Владислав Андреевич on 19.12.2025.
//  Copyright © 2025 Владислав. All rights reserved.
//

struct WarmupAnswerData: Encodable {
    let answer: Int
    let questionId: String
    let deviceId: String

    private enum CodingKeys: String, CodingKey {
        case answer = "answer_id"
        case questionId = "mobile_question_id"
        case deviceId = "device_id"
    }
}
