//
//  WarmupPresenter.swift
//  QuizPlease
//
//  Created by Владислав on 04.08.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import UIKit

protocol WarmupPresenterProtocol {
    var router: WarmupRouterProtocol! { get }
    var questions: [WarmupQuestion]! { get set }
    
    ///In seconds
    var timePassed: Double { get set }
    
    init(view: WarmupViewProtocol, interactor: WarmupInteractorProtocol, router: WarmupRouterProtocol)
    
    func configureViews()
    
    func didPressStartGame()
    
    func shareAction()
    
    func gameEnded()
}

class WarmupPresenter: WarmupPresenterProtocol {
    var router: WarmupRouterProtocol!
    var interactor: WarmupInteractorProtocol
    weak var view: WarmupViewProtocol?
    
    var questions: [WarmupQuestion]!
    
    var timePassed: Double = 0
    
    required init(view: WarmupViewProtocol, interactor: WarmupInteractorProtocol, router: WarmupRouterProtocol) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
    
    func configureViews() {
        view?.configureViews()
        
        interactor.loadQuestions { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .failure(let error):
                print(error)
                self.view?.showErrorConnectingToServerAlert()
            case .success(let questions):
                self.questions = questions
                self.view?.setQuestions()
            }
        }
    }
    
    func didPressStartGame() {
        view?.startGame()
    }
    
    func gameEnded() {
        view?.showResults()
    }
    
    func shareAction() {
        if let viewController = view, let image = UIApplication.shared.makeSnapshot() {
            interactor.shareResults(image, delegate: viewController)
        }
        
    }
    
}
