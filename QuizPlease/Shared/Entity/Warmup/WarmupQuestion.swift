//
//  WarmupQuestion.swift
//  QuizPlease
//
//  Created by Владислав on 28.08.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import Foundation

struct WarmupQuestion: Decodable {
    var type: WarmupQuestionType? = .imageWithText
    var question: String?
    var imageUrl: URL?
    var videoUrl: URL?
    var soundUrl: URL?
    
    var answers: [WarmupAnswer]
}

enum WarmupQuestionType: Int, CaseIterable, Decodable {
    case image, imageWithText, text, soundWithText, videoWithText
}
