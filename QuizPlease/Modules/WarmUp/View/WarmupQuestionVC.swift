//
//  WarmupQuestionVC.swift
//  QuizPlease
//
//  Created by Владислав on 28.08.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import UIKit

class WarmupQuestionVC: UIViewController {

    @IBOutlet weak var videoView: VideoView!
    @IBOutlet weak var questionView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var answerStack: UIStackView!
    
    @IBOutlet weak var imageEdgeInsetConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageLabelSpacingConstraint: NSLayoutConstraint!
    @IBOutlet weak var backgrndHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var labelBottomConstraint: NSLayoutConstraint!
    
    var question: WarmupQuestion!
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
    }
    
    private func configureViews() {
       // backgroundView.addGradient(colors: [.purple, .systemBlue], insertAt: 0)
        answerStack.arrangedSubviews.forEach {
            $0.backgroundColor = UIColor.white.withAlphaComponent(0.1)
        }
    }
    
    private func setupQuestionType() {
        switch question.type {
        case .image:
            imageView.loadImage(url: question.imageUrl)
            imageView.image = UIImage(named: "logoSmall")
            questionLabel.isHidden = true
            
            imageEdgeInsetConstraint.constant = 0
            imageLabelSpacingConstraint.isActive = false
            backgrndHeightConstraint.constant = questionView.frame.height
        case .imageWithText:
            imageView.loadImage(url: question.imageUrl)
            imageView.image = UIImage(named: "logoSmall")
            questionLabel.text = question.text
            
        case .videoWithText:
            imageView.isHidden = true
            videoView.isHidden = false
            videoView.parent = self
            videoView.configurePlayer(url: question.imageUrl)
            questionLabel.text = question.text
            
        case .text:
            imageView.isHidden = true
            questionLabel.text = question.text
            imageLabelSpacingConstraint.isActive = false
            backgrndHeightConstraint.constant = questionView.frame.height
            questionLabel.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: 20).isActive = true
            
        case .soundWithText:
            questionLabel.text = question.text
            backgrndHeightConstraint.constant = questionView.frame.height
            //configure sound view
            break
            
        }
    }
    
    
}
