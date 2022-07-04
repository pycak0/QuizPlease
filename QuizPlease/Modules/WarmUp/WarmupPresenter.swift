//
//  WarmupPresenter.swift
//  QuizPlease
//
//  Created by Владислав on 04.08.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import UIKit

// MARK: - Presenter Protocol
protocol WarmupPresenterProtocol {
    var router: WarmupRouterProtocol! { get }
    var questions: [WarmupQuestion] { get }
    var correctAnswersCount: Int { get }

    init(view: WarmupViewProtocol, interactor: WarmupInteractorProtocol, router: WarmupRouterProtocol)

    func viewDidLoad(_ view: WarmupViewProtocol)
    func didPressStartGame()
    func didAnswer(_ answer: String, for question: WarmupQuestion)
    func shareAction()
    func gameEnded()
}

class WarmupPresenter: WarmupPresenterProtocol {
    private let penaltyTime: Double = 5

    var router: WarmupRouterProtocol!
    var interactor: WarmupInteractorProtocol
    weak var view: WarmupViewProtocol?

    var questions: [WarmupQuestion] = []
    var correctAnswersCount: Int = 0

    private var isGameStarted = false

    private var timestamp: Date = Date()
    private var totalPenaltyTime: Double = 0
    private var timer: Timer?

    private var timePassed: Double = 0 {
        didSet {
            let timePassed = Int(self.timePassed)
            let minutes = timePassed / 60
            let seconds = timePassed % 60
            view?.updatePassedTime(withMinutes: minutes, seconds: seconds)
        }
    }

    required init(view: WarmupViewProtocol, interactor: WarmupInteractorProtocol, router: WarmupRouterProtocol) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }

    // MARK: - Setup
    func viewDidLoad(_ view: WarmupViewProtocol) {
        view.configure()
        view.setPenaltyTimeInfo(penaltySeconds: Int(penaltyTime))
    }

    // MARK: - Actions
    func didPressStartGame() {
        interactor.loadQuestions()
    }

    func didAnswer(_ answer: String, for question: WarmupQuestion) {
        guard let answer = question.answers.first(where: { $0.value == answer }) else { return }
        view?.startLoading()
        interactor.checkAnswerWithId(answer.id, forQuestionWithId: question.id)
    }

    func gameEnded() {
        stopTimer()
        view?.showResults(with: timePassed)
        isGameStarted = false
    }

    func shareAction() {
        if let image = view?.makeResultsSnapshot() {
            router.showShareSheet(with: image)
        } else {
            view?.showSimpleAlert(
                title: "Не удалось поделиться картинкой",
                message: "Пожалуйста, попробуйте поделиться ещё раз"
            )
        }
    }

    // MARK: - Private
    private func startGame() {
        isGameStarted = true
        if questions.count > 0 {
            view?.startGame()
            startTimer()
        } else {
            view?.showSimpleAlert(title: "Новых вопросов пока нет", message: "Но скоро они появятся, загляните чуть позже")
        }
    }

    private func startTimer() {
        timestamp = Date()
        let interval: Double = 1
        timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { [weak self] _ in
            self?.timePassed += interval
        }
    }

    private func stopTimer() {
        timer?.invalidate()
        timer = nil
        let timeElapsed: Double = Date().timeIntervalSince(timestamp) + totalPenaltyTime
        timePassed = timeElapsed
    }
}

// MARK: - WarmupInteractorOutput
extension WarmupPresenter: WarmupInteractorOutput {
    func interactor(_ interactor: WarmupInteractorProtocol, didLoadQuestions questions: [WarmupQuestion]) {
        self.questions = questions
        view?.setQuestions()
        startGame()
    }

    func interactor(_ interactor: WarmupInteractorProtocol, failedToLoadQuestionsWithError error: NetworkServiceError) {
        print(error)
        switch error {
        case .invalidToken:
            view?.showNeedsAuthAlert(title: "Разминка доступна только авторизованным пользователям")
        default:
            view?.showErrorConnectingToServerAlert()
        }
    }

    func interactor(_ interactor: WarmupInteractorProtocol, isAnswerCorrect: Bool, answerId: Int, questionId: String) {
        view?.stopLoading()
        view?.highlightCurrentAnswer(isCorrect: isAnswerCorrect)
        if isAnswerCorrect {
            correctAnswersCount += 1
        } else {
            totalPenaltyTime += penaltyTime
            timePassed += penaltyTime
        }
        interactor.saveQuestionId("\(questionId)")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.view?.showNextQuestion()
        }
    }

    func interactor(_ interactor: WarmupInteractorProtocol, failedToCheckAnswer answerId: Int, questionId: String, error: NetworkServiceError) {
        view?.stopLoading()
        view?.showErrorConnectingToServerAlert()
    }
}
