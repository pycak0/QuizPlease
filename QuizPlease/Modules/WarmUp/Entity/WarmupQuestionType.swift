//
//  WarmupQuestionType.swift
//  QuizPlease
//
//  Created by Владислав on 31.12.2022.
//  Copyright © 2022 Владислав. All rights reserved.
//

import Foundation

/// Enumeration containing possible kinds of warmup questions
enum WarmupQuestionType: Int, CaseIterable, Decodable {
    case image, imageWithText, text, soundWithText, videoWithText
}
