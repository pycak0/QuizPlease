//
//  WarmupPresenter.swift
//  QuizPlease
//
//  Created by Владислав on 04.08.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import UIKit

//MARK:- Presenter Protocol
protocol WarmupPresenterProtocol {
    var router: WarmupRouterProtocol! { get }
    var questions: [WarmupQuestion]! { get set }
    
    ///In seconds
    var timePassed: Double { get set }
    
    var correctAnswersCount: Int { get }
    
    init(view: WarmupViewProtocol, interactor: WarmupInteractorProtocol, router: WarmupRouterProtocol)
    
    func setupView()
    
    func didPressStartGame()
    
    func didAnswer(_ answer: String, for question: WarmupQuestion)
    
    func shareAction()
    
    func gameEnded()
}

class WarmupPresenter: WarmupPresenterProtocol {
    var router: WarmupRouterProtocol!
    var interactor: WarmupInteractorProtocol
    weak var view: WarmupViewProtocol?
    
    var questions: [WarmupQuestion]!
    
    var correctAnswersCount: Int = 0
    
    var timePassed: Double = 0 {
        didSet {
            view?.updatePassedMinutes(with: Int(timePassed) / 60)
        }
    }
    
    required init(view: WarmupViewProtocol, interactor: WarmupInteractorProtocol, router: WarmupRouterProtocol) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
    
    //MARK:- Setup
    func setupView() {
        view?.configure()
        
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
    
    //MARK:- Actions
    func didPressStartGame() {
        if questions.count > 0 {
            view?.startGame()
        } else {
            view?.showSimpleAlert(title: "Новых вопросов пока нет", message: "Но скоро они появятся, загляните чуть позже")
        }
    }
    
    func didAnswer(_ answer: String, for question: WarmupQuestion) {
        //guard questions.contains { $0 == question }
        if question.isAnswerCorrect(answer) {
            correctAnswersCount += 1
        }
        let id = "\(question.id)"
        interactor.saveQuestionId(id)
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
