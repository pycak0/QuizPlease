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
    func loadQuestions(completion: @escaping (Result<[WarmupQuestion], SessionError>) -> Void)
    
    func shareResults(_ image: UIImage, delegate: UIViewController)
    
    func saveQuestionId(_ id: String)
    
    func loadSavedQuestionIds(completion: @escaping ([String]) -> Void)
}

class WarmupInteractor: WarmupInteractorProtocol {
    func loadQuestions(completion: @escaping (Result<[WarmupQuestion], SessionError>) -> Void) {
        NetworkService.shared.getWarmupQuestions { [weak self] serverResult in
            guard let self = self else { return }
            switch serverResult {
            case let .failure(error):
                completion(.failure(error))
            case let .success(questions):
                self.loadSavedQuestionIds { (savedQuestions) in
                    let filteredData = questions + questions + questions + questions // .filter { !savedQuestions.contains("\($0.id)") }
                    completion(.success(filteredData))
                }
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
}
