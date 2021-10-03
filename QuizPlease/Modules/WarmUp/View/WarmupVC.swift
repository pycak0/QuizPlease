//
//MARK:  WarmupVC.swift
//  QuizPlease
//
//  Created by Владислав on 30.07.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import UIKit
import UICircularProgressRing

// MARK: - View Protocol
protocol WarmupViewProtocol: UIViewController, LoadingIndicator {
    var presenter: WarmupPresenterProtocol! { get set }
    
    func configure()
    func setPenaltyTimeInfo(penaltySeconds: Int)
    func startGame()
    func showNextQuestion()
    func highlightCurrentAnswer(isCorrect: Bool)
    func setQuestions()
    func showResults(with totalTimePassed: Double)
    func updatePassedTime(withMinutes minutes: Int, seconds: Int)
}

class WarmupVC: UIViewController {
    var presenter: WarmupPresenterProtocol!
    private weak var pageVC: QuestionPageVC!
    
    // MARK: - Outlets
    @IBOutlet private weak var previewStack: UIStackView!
    @IBOutlet private weak var startButton: ScalingButton!
    @IBOutlet private weak var container: UIView!
    @IBOutlet private var progressRing: UICircularProgressRing!
    @IBOutlet private weak var minutesPassedItem: UIBarButtonItem!
    
    @IBOutlet private weak var completionView: UIView!
    @IBOutlet private weak var resultsView: UIView!
    @IBOutlet private weak var resultTextLabel: UILabel!
    @IBOutlet private weak var minutesLabel: UILabel!
    @IBOutlet private weak var secondsLabel: UILabel!
    @IBOutlet private weak var secondPartsLabel: UILabel!
    @IBOutlet private weak var infoLabel: UILabel!
    private var activityIndicator = UIActivityIndicatorView()
    
            
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        WarmupConfigurator().configure(self)
        presenter.viewDidLoad(self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.barStyle = .black
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        resultsView.layer.sublayers?.removeAll(where: { $0 is CAGradientLayer })
        resultsView.addGradient(.warmupItems)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        pageVC.currentViewController?.stopMedia()
    }
    
    // MARK: - Prepare for Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "WarmupPageVCEmbedded",
              let vc = segue.destination as? QuestionPageVC
        else { return }
        pageVC = vc
    }
    
    @IBAction private func startButtonPressed(_ sender: UIButton) {
        presenter.didPressStartGame()
    }
    
    @IBAction private func shareButtonPressed(_ sender: Any) {
        presenter.shareAction()
    }
    
    // MARK: - Configure Timer View
    private func configureTimerRing() {
        progressRing.isHidden = true
        progressRing.style = .ontop
        progressRing.startAngle = 270
        progressRing.endAngle = 270
        progressRing.outerRingWidth = 5
        progressRing.outerRingColor = UIColor.black.withAlphaComponent(0.1)
        progressRing.innerRingWidth = 5
        progressRing.innerRingColor = .lightGreen
        progressRing.minValue = 0
        progressRing.maxValue = 60
        
        progressRing.font = .gilroy(.semibold, size: 15)
        progressRing.fontColor = .white
        let formatter = UICircularProgressRingFormatter(valueIndicator: "", rightToLeft: true, showFloatingPoint: false, decimalPlaces: 0)
        progressRing.valueFormatter = formatter

    }
    
    // MARK: - Configure Result Labels
    private func configureResultLabels() {
        let bgColor = UIColor.white.withAlphaComponent(0.1)
        let cRadius: CGFloat = 10
        minutesLabel.backgroundColor = bgColor
        secondsLabel.backgroundColor = bgColor
        secondPartsLabel.backgroundColor = bgColor
        
        minutesLabel.layer.cornerRadius = cRadius
        secondsLabel.layer.cornerRadius = cRadius
        secondPartsLabel.layer.cornerRadius = cRadius
        
    }
    
    // MARK: - Set Results
    private func setResults(with totalTimePassed: Double) {
        let count = presenter.questions.count
        let correct = presenter.correctAnswersCount
        let correctQuestionsPrompt = correct.string(withAssociatedMaleWord: "вопрос")
        resultTextLabel.text = "Я прошел разминку Квиз, плиз! и ответил правильно на \(correctQuestionsPrompt) из \(count)"
        let passedTime = totalTimePassed
        minutesLabel.text = String(format: "%02d", Int(passedTime) / 60)
        secondsLabel.text = String(format: "%02d", Int(passedTime) % 60)
        let parts = Int(100 * (passedTime - passedTime.rounded(.down)))
        secondPartsLabel.text = String(format: "%02d", parts)
    }
}

// MARK: - View Protocol Implemenation
extension WarmupVC: WarmupViewProtocol {
    func configure() {
        configureTimerRing()
        configureResultLabels()
    }
    
    func setPenaltyTimeInfo(penaltySeconds: Int) {
        let secondsFormatted = penaltySeconds.string(withAssociatedFirstCaseWord: "секунда")
        infoLabel.text = "Тут будут появляться новые вопросы разминки. Ваша задача — ответить правильно и максимально быстро. В случае неправильного ответа к таймеру добавится \(secondsFormatted)."
    }
    
    func startGame() {
        previewStack.isHidden = true
        container.isHidden = false
        pageVC.start()
        
        progressRing.isHidden = false
    }
    
    func highlightCurrentAnswer(isCorrect: Bool) {
        pageVC.currentViewController?.highlightAnswer(isCorrect: isCorrect)
    }
    
    func showNextQuestion() {
        pageVC.next()
    }
    
    func setQuestions() {
        pageVC.configure(with: presenter.questions, delegate: self)
    }
    
    func showResults(with totalTimePassed: Double) {
        navigationItem.setRightBarButtonItems(nil, animated: true)
        completionView.isHidden = false
        setResults(with: totalTimePassed)
    }
    
    func updatePassedTime(withMinutes minutes: Int, seconds: Int) {
        let text = minutes > 0 ? "\(minutes) мин +" : ""
        minutesPassedItem?.title = text
        progressRing?.startProgress(to: CGFloat(seconds), duration: 0.2)
    }
    
    func startLoading() {
        //activityIndicator.enableCentered(in: view, color: .systemBlue)
    }
    
    func stopLoading() {
        //activityIndicator.stopAnimating()
    }
}

// MARK: - Answer Delegate
extension WarmupVC: WarmupQuestionVCAnswerDelegate {
    func questionVC(_ vc: WarmupQuestionVC, didSelectAnswer answer: String, forQuestion question: WarmupQuestion) {
        presenter.didAnswer(answer, for: question)
    }
}

// MARK: - Page VC Delegate
extension WarmupVC: QuestionPageVCDelegate {
    func questionsDidEnd() {
        presenter.gameEnded()
    }
}
