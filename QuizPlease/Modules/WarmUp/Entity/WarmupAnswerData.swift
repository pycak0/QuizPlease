//
//  WarmupAnswerData.swift
//  QuizPlease
//
//  Created by Русаков Владислав Андреевич on 19.12.2025.
//  Copyright © 2025 Владислав. All rights reserved.
//

struct WarmupAnswerData: Encodable {
    let answer: Int
    let questionId: Int
    let deviceId: String
}
