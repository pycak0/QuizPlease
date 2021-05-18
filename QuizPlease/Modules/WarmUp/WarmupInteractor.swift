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
    func loadQuestions()
    func shareResults(_ image: UIImage, delegate: UIViewController)
    func saveQuestionId(_ id: String)
    func loadSavedQuestionIds(completion: @escaping ([String]) -> Void)
    func checkAnswerWithId(_ answerId: Int, forQuestionWithId id: String)
}

protocol WarmupInteractorOutput: AnyObject {
    func interactor(_ interactor: WarmupInteractorProtocol, isAnswerCorrect: Bool, answerId: Int, questionId: String)
    func interactor(_ interactor: WarmupInteractorProtocol, failedToCheckAnswer answerId: Int, questionId: String, error: SessionError)
    func interactor(_ interactor: WarmupInteractorProtocol, didLoadQuestions: [WarmupQuestion])
    func interactor(_ interactor: WarmupInteractorProtocol, failedToLoadQuestionsWithError: SessionError)
}

class WarmupInteractor: WarmupInteractorProtocol {
    weak var output: WarmupInteractorOutput?
    
    func loadQuestions() {
        MockNetworkService.shared.getWarmupQuestions { [weak self] serverResult in
            guard let self = self else { return }
            switch serverResult {
            case let .failure(error):
                switch error {
                case let .serverError(statusCode):
                    if statusCode == 422 {
                        self.output?.interactor(self, didLoadQuestions: [])
                    } else {
                        fallthrough
                    }
                default:
                    self.output?.interactor(self, failedToLoadQuestionsWithError: error)
                }
            case let .success(questions):
//                self.loadSavedQuestionIds { (savedQuestions) in
//                    let savedSet = Set(savedQuestions)
//                    let filteredData = questions
//                        .filter { !savedSet.contains("\($0.id)") }
//                        .shuffled()
//                        .prefix(5)
                    self.output?.interactor(self, didLoadQuestions: Array(questions))
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
    
    func checkAnswerWithId(_ answerId: Int, forQuestionWithId questionId: String) {
        self.output?.interactor(self, isAnswerCorrect: Int.random(in: 0...1) == 1, answerId: answerId, questionId: questionId)
        
        
//        NetworkService.shared.sendWarmupAnswer(questionId: questionId, answerId: answerId) { (result) in
//            switch result {
//            case let .failure(error):
//                self.output?.interactor(self, failedToCheckAnswer: answerId, questionId: questionId, error: error)
//            case let .success(answerResponse):
//                self.output?.interactor(self, isAnswerCorrect: answerResponse.message, answerId: answerId, questionId: questionId)
//            }
//        }
    }
}

class MockNetworkService {
    private init() {}
    static let shared = MockNetworkService()

    func getWarmupQuestions(completion: @escaping (Result<[WarmupQuestion], SessionError>) -> Void) {
        let path = Bundle.main.path(forResource: "MockWarmupQuestionsData", ofType: "json")!
        let data = FileManager.default.contents(atPath: path)!
        let response = try! JSONDecoder().decode(ServerResponse<[WarmupQuestion]>.self, from: data)
        completion(.success(response.data))
    }
}
