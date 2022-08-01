//
//  WarmupInteractor.swift
//  QuizPlease
//
//  Created by Владислав on 04.08.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import UIKit

// MARK: - Interactor Protocol

protocol WarmupInteractorProtocol {
    /// must be an `unowned var`
    var output: WarmupInteractorOutput! { get set }
    init(questionsService: WarmupQuestionsService)
    func loadQuestions()
    func saveQuestionId(_ id: String)
    func loadSavedQuestionIds(completion: @escaping ([String]) -> Void)
    func checkAnswerWithId(_ answerId: Int, forQuestionWithId id: String)
}

protocol WarmupInteractorOutput: AnyObject {

    func interactor(
        _ interactor: WarmupInteractorProtocol,
        isAnswerCorrect: Bool,
        answerId: Int,
        questionId: String
    )

    func interactor(
        _ interactor: WarmupInteractorProtocol,
        failedToCheckAnswer answerId: Int,
        questionId: String,
        error: NetworkServiceError
    )

    func interactor(
        _ interactor: WarmupInteractorProtocol,
        didLoadQuestions: [WarmupQuestion]
    )

    func interactor(
        _ interactor: WarmupInteractorProtocol,
        failedToLoadQuestionsWithError: NetworkServiceError
    )
}

final class WarmupInteractor: WarmupInteractorProtocol {
    unowned var output: WarmupInteractorOutput!
    let questionsService: WarmupQuestionsService

    required init(questionsService: WarmupQuestionsService) {
        self.questionsService = questionsService
    }

    func loadQuestions() {
        questionsService.getWarmupQuestions { [weak self] serverResult in
            guard let self = self else { return }
            switch serverResult {
            case let .failure(error):
                switch error {
                case let .serverError(statusCode):
                    if statusCode == 422 {
                        self.output.interactor(self, didLoadQuestions: [])
                    } else {
                        fallthrough
                    }
                default:
                    self.output.interactor(self, failedToLoadQuestionsWithError: error)
                }
            case let .success(questions):
//                self.loadSavedQuestionIds { (savedQuestions) in
//                    let savedSet = Set(savedQuestions)
//                    let filteredData = questions
//                        .filter { !savedSet.contains("\($0.id)") }
//                        .shuffled()
//                        .prefix(5)
                    self.output.interactor(self, didLoadQuestions: Array(questions))
//                }
            }
        }
    }

    func saveQuestionId(_ id: String) {
        DefaultsManager.shared.saveAnsweredQuestionId(id)
    }

    func loadSavedQuestionIds(completion: @escaping ([String]) -> Void) {
        // DispatchQueue.global().async {
            let ids = DefaultsManager.shared.getSavedQuestionIds() ?? []
            // DispatchQueue.main.async {
                completion(ids)
            // }
        // }
    }

    func checkAnswerWithId(_ answerId: Int, forQuestionWithId questionId: String) {
        questionsService.sendWarmupAnswer(
            questionId: questionId,
            answerId: answerId
        ) { [weak self] result in
            guard let self = self else { return }

            switch result {
            case let .failure(error):
                self.output.interactor(
                    self,
                    failedToCheckAnswer: answerId,
                    questionId: questionId,
                    error: error
                )
            case let .success(answerResponse):
                self.output.interactor(
                    self,
                    isAnswerCorrect: answerResponse.message,
                    answerId: answerId,
                    questionId: questionId
                )
            }
        }
    }
}
