//
//  WarmupInteractor.swift
//  QuizPlease
//
//  Created by Владислав on 04.08.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import UIKit

//MARK:- Interactor Protocol
protocol WarmupInteractorProtocol {
    ///must be weak
    var output: WarmupInteractorOutput? { get set }
    func loadQuestions(completion: @escaping (Result<[WarmupQuestion], SessionError>) -> Void)
    func shareResults(_ image: UIImage, delegate: UIViewController)
    func saveQuestionId(_ id: String)
    func loadSavedQuestionIds(completion: @escaping ([String]) -> Void)
    func checkAnswerWithId(_ answerId: Int, forQuestionWithId id: String)
}

protocol WarmupInteractorOutput: class {
    func interactor(_ interactor: WarmupInteractorProtocol, isAnswerCorrect: Bool, answerId: Int, questionId: String)
    func interactor(_ interactor: WarmupInteractorProtocol, failedToCheckAnswer answerId: Int, questionId: String, error: SessionError)
}

class WarmupInteractor: WarmupInteractorProtocol {
    weak var output: WarmupInteractorOutput?
    
    func loadQuestions(completion: @escaping (Result<[WarmupQuestion], SessionError>) -> Void) {
        NetworkService.shared.getWarmupQuestions { serverResult in
            switch serverResult {
            case let .failure(error):
                completion(.failure(error))
            case let .success(questions):
//                self.loadSavedQuestionIds { (savedQuestions) in
//                    let savedSet = Set(savedQuestions)
//                    let filteredData = questions
//                        .filter { !savedSet.contains("\($0.id)") }
//                        .shuffled()
//                        .prefix(5)
                    completion(.success(Array(questions)))
//                }
            }
        }
    }
    
    func shareResults(_ image: UIImage, delegate: UIViewController) {
        ShareManager.presentShareSheet(for: image, delegate: delegate)
    }
    
    func saveQuestionId(_ id: String) {
        DefaultsManager.shared.saveAnsweredQuestionId(id)
    }
    
    func loadSavedQuestionIds(completion: @escaping ([String]) -> Void) {
        //DispatchQueue.global().async {
            let ids = DefaultsManager.shared.getSavedQuestionIds() ?? []
            //DispatchQueue.main.async {
                completion(ids)
            //}
        //}
    }
    
    func checkAnswerWithId(_ answerId: Int, forQuestionWithId id: String) {
        NetworkService.shared.sendWarmupAnswer(questionId: id, answerId: answerId) { (result) in
            self.output?.interactor(self, isAnswerCorrect: Int.random(in: 0...1) == 1, answerId: answerId, questionId: id)
            return
            
            switch result {
            case let .failure(error):
                self.output?.interactor(self, failedToCheckAnswer: answerId, questionId: id, error: error)
            case let .success(answerResponse):
                self.output?.interactor(self, isAnswerCorrect: answerResponse.message, answerId: answerId, questionId: id)
            }
        }
    }
}
