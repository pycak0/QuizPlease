//
//  WarmupQuestionVC.swift
//  QuizPlease
//
//  Created by Владислав on 28.08.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import UIKit

//MARK:- Delegate Protocol
protocol WarmupQuestionVCAnswerDelegate: class {
    func questionVC(_ vc: WarmupQuestionVC, didSelectAnswer answer: String, forQuestion question: WarmupQuestion)
}

class WarmupQuestionVC: UIViewController {

    //MARK:- Outlets
    @IBOutlet weak var videoView: VideoView!
    @IBOutlet weak var questionView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var answerStack: UIStackView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var imageEdgeInsetConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageLabelSpacingConstraint: NSLayoutConstraint!
    @IBOutlet weak var backgrndHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var labelBottomConstraint: NSLayoutConstraint!
    
    var question: WarmupQuestion!
    
    weak var delegate: WarmupQuestionVCAnswerDelegate?
        
    @IBAction func answerButtonPressed(_ sender: UIButton) {
        delegate?.questionVC(self, didSelectAnswer: sender.titleLabel!.text!, forQuestion: question)
    }
    
    //MARK:- Init
    private override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    convenience init(_ question: WarmupQuestion) {
        self.init()
        self.question = question
    }
    
    //MARK:- Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
    }
    
    private func configureViews() {
        //backgroundView.addGradient(.warmupItems)
        
        for (index, button) in (answerStack.arrangedSubviews as! [UIButton]).enumerated() {
            button.backgroundColor = UIColor.white.withAlphaComponent(0.1)
            button.setTitle(question.answers[index].value, for: .normal)
        }
        
        setupQuestionType()
    }
    
    //MARK:- Setup Question
    private func setupQuestionType() {
        switch question.type {
        case .image:
            loadImage()
            //imageView.image = UIImage(named: "logoSmall")
            questionLabel.isHidden = true
            
            imageEdgeInsetConstraint.constant = 0
            imageLabelSpacingConstraint.isActive = false
            backgrndHeightConstraint.constant = questionView.frame.height
        case .imageWithText:
            loadImage()
            //imageView.image = UIImage(named: "logoSmall")
            questionLabel.text = question.question
            
        case .videoWithText:
            imageView.isHidden = true
            videoView.isHidden = false
            videoView.parent = self
            videoView.configurePlayer(url: question.videoUrl)
            questionLabel.text = question.question
            
        case .text:
            imageView.isHidden = true
            questionLabel.text = question.question
            imageLabelSpacingConstraint.isActive = false
            backgrndHeightConstraint.constant = questionView.frame.height
            questionLabel.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: 20).isActive = true
            
        case .soundWithText:
            questionLabel.text = question.question
            backgrndHeightConstraint.constant = questionView.frame.height
            //configure sound view
            break
            
        //default: break
            
        }
    }
    
    private func loadImage() {
        activityIndicator.startAnimating()
        imageView.loadImage(url: question.imageUrl) { _ in
            self.activityIndicator.stopAnimating()
        }
    }
    
}
