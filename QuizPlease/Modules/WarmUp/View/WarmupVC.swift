//
//MARK:  WarmupVC.swift
//  QuizPlease
//
//  Created by Владислав on 30.07.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import UIKit

//MARK:- View Protocol
protocol WarmupViewProtocol: UIViewController {
    var configurator: WarmupConfiguratorProtocol { get }
    var presenter: WarmupPresenterProtocol! { get set }
    
    func configureViews()
    
    func startGame()
    func setQuestions()
}

class WarmupVC: UIViewController {
    let configurator: WarmupConfiguratorProtocol = WarmupConfigurator()
    var presenter: WarmupPresenterProtocol!
    
    @IBOutlet weak var previewStack: UIStackView!
    @IBOutlet weak var container: UIView!
    weak var pageVC: QuestionPageVC!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configurator.configure(self)
        presenter.configureViews()

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "WarmupPageVCEmbedded" else {
            presenter.router.prepare(for: segue, sender: sender)
            return
        }
        guard let vc = segue.destination as? QuestionPageVC else { return }
        pageVC = vc
    }
    
    @IBAction func startGamePressed(_ sender: UIButton) {
        presenter.didPressStartGame()
    }
    
}

//MARK:- View Protocol Implemenation
extension WarmupVC: WarmupViewProtocol {
    func configureViews() {
        //
    }
    
    func startGame() {
        previewStack.isHidden = true
        container.isHidden = false
        pageVC.start()
    }
    
    func setQuestions() {
        pageVC.configure(with: presenter.questions, delegate: self)
    }
}


extension WarmupVC: WarmupQuestionVCAnswerDelegate {
    func questionVC(_ vc: WarmupQuestionVC, didPressButtonWith answer: String) {
        pageVC.next()
    }
}
