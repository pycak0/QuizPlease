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
    var questions: [WarmupQuestion] { get }
    
    ///In seconds
    var timePassed: Double { get }
    
    var correctAnswersCount: Int { get }
    
    init(view: WarmupViewProtocol, interactor: WarmupInteractorProtocol, router: WarmupRouterProtocol)
    
    func viewDidLoad(_ view: WarmupViewProtocol)
    func didPressStartGame()
    func didAnswer(_ answer: String, for question: WarmupQuestion)
    func shareAction()
    func gameEnded()
}

class WarmupPresenter: WarmupPresenterProtocol {
    var router: WarmupRouterProtocol!
    var interactor: WarmupInteractorProtocol
    weak var view: WarmupViewProtocol?
    
    var questions: [WarmupQuestion] = []
    
    var correctAnswersCount: Int = 0
    
    var timePassed: Double = 0 {
        didSet {
            let timePassed = Int(self.timePassed)
            let minutes = timePassed / 60
            let seconds = timePassed % 60
            view?.updatePassedTime(withMinutes: minutes, seconds: seconds)
        }
    }
    
    var timestamp: Date = Date()
    
    private var timer: Timer?
    
    required init(view: WarmupViewProtocol, interactor: WarmupInteractorProtocol, router: WarmupRouterProtocol) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
    
    //MARK:- Setup
    func viewDidLoad(_ view: WarmupViewProtocol) {
        view.configure()
        
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
            startTimer()
        } else {
            view?.showSimpleAlert(title: "Новых вопросов пока нет", message: "Но скоро они появятся, загляните чуть позже")
        }
    }
    
    func didAnswer(_ answer: String, for question: WarmupQuestion) {
        //guard questions.contains { $0 == question }
        guard let answer = question.answers.first(where: { $0.value == answer }) else { return }
        view?.enableLoading()
        interactor.checkAnswerWithId(answer.id, forQuestionWithId: question.id)
    }
    
    func gameEnded() {
        stopTimer()
        view?.showResults()
    }
    
    func shareAction() {
        if let viewController = view, let image = UIApplication.shared.makeSnapshot() {
            interactor.shareResults(image, delegate: viewController)
        }
    }
    
    //MARK:- Private
    private func startTimer() {
        timestamp = Date()
        let interval: Double = 1
        timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { t in
            self.timePassed += interval
        }
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
        
        let timeElapsed: Double = Date().timeIntervalSince(timestamp)
        print(timeElapsed)
        print(timePassed)
    }
    
}

//MARK:- WarmupInteractorOutput
extension WarmupPresenter: WarmupInteractorOutput {
    func interactor(_ interactor: WarmupInteractorProtocol, isAnswerCorrect: Bool, answerId: Int, questionId: String) {
        view?.disableLoading()
        view?.highlightCurrentAnswer(isCorrect: isAnswerCorrect)
        if isAnswerCorrect {
            correctAnswersCount += 1
        } else {
            timePassed += 15
        }
        interactor.saveQuestionId("\(questionId)")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.view?.showNextQuestion()
        }
    }
    
    func interactor(_ interactor: WarmupInteractorProtocol, failedToCheckAnswer answerId: Int, questionId: String, error: SessionError) {
        view?.disableLoading()
        view?.showErrorConnectingToServerAlert()
    }
}
