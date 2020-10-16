//
//  WarmupInteractor.swift
//  QuizPlease
//
//  Created by Владислав on 04.08.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import UIKit

protocol WarmupInteractorProtocol {
    func loadQuestions(completion: @escaping (Result<[WarmupQuestion], SessionError>) -> Void)
    
    func shareResults(_ image: UIImage, delegate: UIViewController)
    
    func saveQuestionId(_ id: String)
}

class WarmupInteractor: WarmupInteractorProtocol {
    func loadQuestions(completion: @escaping (Result<[WarmupQuestion], SessionError>) -> Void) {
        NetworkService.shared.getWarmupQuestions(completion: completion)
    }
    
    func shareResults(_ image: UIImage, delegate: UIViewController) {
        ShareManager.presentShareSheet(for: image, delegate: delegate)
    }
    
    func saveQuestionId(_ id: String) {
        DefaultsManager.shared.saveAnsweredQuestionId(id)
    }
}
