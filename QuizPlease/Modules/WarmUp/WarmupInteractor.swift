//
//  WarmupInteractor.swift
//  QuizPlease
//
//  Created by Владислав on 04.08.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import Foundation

protocol WarmupInteractorProtocol {
    func loadQuestions(completion: (Result<[WarmupQuestion], SessionError>) -> Void)
}

class WarmupInteractor: WarmupInteractorProtocol {
    func loadQuestions(completion: (Result<[WarmupQuestion], SessionError>) -> Void) {
        var questions = [WarmupQuestion]()
        for i in 0...3 {
            questions.append(WarmupQuestion(type: WarmupQuestionType(rawValue: i)!, text: "Test \(i)", imageUrl: nil, videoUrl: nil, soundUrl: nil, answerVariants: Array(repeating: "foo", count: 4), correctAnswer: "foo"))
        }
        completion(.success(questions))
    }
}
