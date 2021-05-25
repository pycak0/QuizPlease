//
//  WarmupQuestionVC.swift
//  QuizPlease
//
//  Created by Владислав on 28.08.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import UIKit

//MARK:- Delegate Protocol
protocol WarmupQuestionVCAnswerDelegate: AnyObject {
    func questionVC(_ vc: WarmupQuestionVC, didSelectAnswer answer: String, forQuestion question: WarmupQuestion)
}

class WarmupQuestionVC: UIViewController {

    //MARK:- Outlets
    @IBOutlet private weak var videoView: VideoView!
    @IBOutlet private weak var questionView: UIView!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var questionLabel: UILabel!
    @IBOutlet private weak var backgroundView: UIView!
    @IBOutlet private weak var answerStack: UIStackView!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet private weak var audioView: AudioView!

    @IBOutlet private weak var imageEdgeInsetConstraint: NSLayoutConstraint!
    @IBOutlet private weak var imageLabelSpacingConstraint: NSLayoutConstraint!
    @IBOutlet private weak var backgroundHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var labelBottomConstraint: NSLayoutConstraint!
    
    private weak var selectedButton: WarmupAnswerButton?
        
    //MARK:- Public
    var question: WarmupQuestion!
    
    weak var delegate: WarmupQuestionVCAnswerDelegate?
    
    func highlightAnswer(isCorrect: Bool) {
        let color: UIColor = isCorrect ? .lightGreen : .red
        selectedButton?.backgroundColor = color
        if !isCorrect {
            selectedButton?.shakeAnimation()
        }
    }
    
    func stopMedia() {
        audioView?.pause()
        videoView?.pause()
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
    
    @objc
    private func answerButtonPressed(_ sender: WarmupAnswerButton) {
        view.isUserInteractionEnabled = false
        selectedButton = sender
        
        stopMedia()
        
        delegate?.questionVC(self, didSelectAnswer: sender.title(for: .normal) ?? "", forQuestion: question)
    }
    
    private func configureViews() {
        answerStack.arrangedSubviews.forEach { self.answerStack.removeArrangedSubview($0); $0.removeFromSuperview() }
        
        for answer in question.answers {
            let button = WarmupAnswerButton(title: answer.value)
            button.addTarget(self, action: #selector(answerButtonPressed(_:)), for: .touchUpInside)
            answerStack.addArrangedSubview(button)
        }
        
        audioView.backgroundColor = UIColor.white.withAlphaComponent(0.1)
        setupQuestionType()
    }
    
    //MARK:- Setup Question Type
    private func setupQuestionType() {
        switch question.type {
        
            //MARK:- • image
        case .image:
            loadImage()
            //imageView.image = UIImage(named: "logoSmall")
            questionLabel.isHidden = true
            
            imageEdgeInsetConstraint.constant = 0
            imageLabelSpacingConstraint.isActive = false
            setBackgroundViewHeight()
            
            //MARK:- • image w/text
        case .imageWithText:
            loadImage()
            //imageView.image = UIImage(named: "logoSmall")
            questionLabel.text = question.question
            
            //MARK:- • video w/text
        case .videoWithText:
            imageView.isHidden = true
            videoView.isHidden = false
            videoView.configureVideoView(parent: self)
            videoView.configurePlayer(url: question.videoUrl)
            questionLabel.text = question.question
            
            //MARK:- • text
        case .text:
            imageView.isHidden = true
            imageLabelSpacingConstraint.isActive = false
            setBackgroundViewHeight()
            questionLabel.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: 20).isActive = true
            questionLabel.text = question.question
            
            //MARK:- • sound
        case .soundWithText:
            questionLabel.text = question.question
            setBackgroundViewHeight()
            activityIndicator.startAnimating()
            audioView.isHidden = false
            audioView.configure(with: question.soundUrl)
            audioView.delegate = self
            audioView.play()
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
    
    private func setBackgroundViewHeight() {
        backgroundHeightConstraint.isActive = false
        backgroundView.heightAnchor.constraint(equalTo: questionView.heightAnchor).isActive = true
    }
    
}

//MARK:- AudioViewDelegate
extension WarmupQuestionVC: AudioViewDelegate {
    func didFinishPlayingAudio(in audioView: AudioView) {
        //
    }
    
    func audioView(_ audioView: AudioView, didUpdateProgress progress: Double) {
        activityIndicator.stopAnimating()
    }
    
    func audioView(_ audioView: AudioView, didFailToConfigurePlayerWithError error: Error) {
        print(error)
    }
}
