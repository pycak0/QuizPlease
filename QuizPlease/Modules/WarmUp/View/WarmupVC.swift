//
//MARK:  WarmupVC.swift
//  QuizPlease
//
//  Created by Владислав on 30.07.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import UIKit
import UICircularProgressRing

//MARK:- View Protocol
protocol WarmupViewProtocol: UIViewController {
    var configurator: WarmupConfiguratorProtocol { get }
    var presenter: WarmupPresenterProtocol! { get set }
    
    func configure()
    
    func startGame()
    func setQuestions()
    
    func showResults()
}

class WarmupVC: UIViewController {
    let configurator: WarmupConfiguratorProtocol = WarmupConfigurator()
    var presenter: WarmupPresenterProtocol!
    
    @IBOutlet weak var previewStack: UIStackView!
    @IBOutlet weak var startButton: ScalingButton!
    @IBOutlet weak var container: UIView!
    @IBOutlet weak var timerRing: UICircularTimerRing!
    
    @IBOutlet weak var completionView: UIView!
    @IBOutlet weak var resultsView: UIView!
    @IBOutlet weak var resultTextLabel: UILabel!
    @IBOutlet weak var minutesLabel: UILabel!
    @IBOutlet weak var secondsLabel: UILabel!
    @IBOutlet weak var secondPartsLabel: UILabel!
    
    weak var pageVC: QuestionPageVC!
    
    var isGameStarted = false
    
    //MARK:- Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configurator.configure(self)
        presenter.setupView()

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "WarmupPageVCEmbedded" else {
            presenter.router.prepare(for: segue, sender: sender)
            return
        }
        guard let vc = segue.destination as? QuestionPageVC else { return }
        pageVC = vc
    }
    
    
    @IBAction func startButtonPressed(_ sender: UIButton) {
        presenter.didPressStartGame()
    }
    
    @IBAction func shareButtonPressed(_ sender: Any) {
        presenter.shareAction()
    }
    
    //MARK:- Configure Timer View
    private func configureTimerRing() {
        timerRing.isHidden = true
        timerRing.style = .ontop
        timerRing.startAngle = 270
        timerRing.endAngle = 270
        timerRing.outerRingWidth = 5
        timerRing.outerRingColor = UIColor.black.withAlphaComponent(0.1)
        timerRing.innerRingWidth = 5
        timerRing.innerRingColor = .lightGreen
        let formatter = UICircularProgressRingFormatter(valueIndicator: "", rightToLeft: true, showFloatingPoint: false, decimalPlaces: 0)
        timerRing.valueFormatter = formatter
       // timerRing.shouldShowValueText = false
    }
    
    //MARK:- Configure Result Labels
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
    
    //MARK:- Start Timer
    private func startTimer() {
        timerRing.startTimer(from: 0, to: 60) { [weak self] (timerState) in
            guard let self = self else { return }
            switch timerState {
            case .finished:
                self.presenter.timePassed += 5
                self.startTimer()
            case .continued(elapsedTime: _):
                break
            case let .paused(elpasedTime: time):
                if let time = time {
                    self.presenter.timePassed += time
                }
            }
        }
        
    }
    
    //MARK:- Set Results
    private func setResults() {
        let count = presenter.questions.count
        let correct = presenter.correctAnswersCount
        let correctQuestionsPrompt = correct.string(withAssociatedMaleWord: "вопрос")
        resultTextLabel.text = "Я прошел разминку Квиз, плиз! и ответил правильно на \(correctQuestionsPrompt) из \(count)"
        let passedTime = presenter.timePassed
        minutesLabel.text = String(format: "%02d", Int(passedTime) / 60)
        secondsLabel.text = String(format: "%02d", Int(passedTime) % 60)
        let parts = Int(100 * (passedTime - passedTime.rounded(.down)))
        secondPartsLabel.text = String(format: "%02d", parts)
    }
    
    
}

//MARK:- View Protocol Implemenation
extension WarmupVC: WarmupViewProtocol {
    func configure() {
        configureTimerRing()
        configureResultLabels()
        resultsView.addGradient(.warmupItems)
    }
    
    func startGame() {
        previewStack.isHidden = true
        container.isHidden = false
        pageVC.start()
        
        timerRing.isHidden = false
        
        startTimer()
        isGameStarted = true
    }
    
    func setQuestions() {
        pageVC.configure(with: presenter.questions, delegate: self)
    }
    
    func showResults() {
        timerRing.isHidden = true
        timerRing.alpha = 0
        completionView.isHidden = false
        setResults()
    }
}

//MARK:- Answer Delegate
extension WarmupVC: WarmupQuestionVCAnswerDelegate {
    func questionVC(_ vc: WarmupQuestionVC, didSelectAnswer answer: String, forQuestion question: WarmupQuestion) {
        presenter.didAnswer(answer, for: question)
        timerRing.pauseTimer()
        pageVC.next()
        timerRing.continueTimer()
    }
}

//MARK:- Page VC Delegate
extension WarmupVC: QuestionPageVCDelegate {
    func questionsDidEnd() {
        timerRing.pauseTimer()
        presenter.gameEnded()
    }
}
