//
//MARK:  HomeGameVideoVC.swift
//  QuizPlease
//
//  Created by Владислав on 24.08.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import UIKit

fileprivate enum Constants {
    static let buttonCornerRadius: CGFloat = 20
    static let videoCornerRadius: CGFloat = 30
    static let gameRulesPath = "/files/quizplease_home_rules.pdf"
}

class HomeGameVideoVC: UIViewController {
    var homeGame: HomeGame! = HomeGame()
    
    @IBOutlet private weak var descriptionLabel: UILabel!

    @IBOutlet private weak var backgroundImageView: UIImageView! {
        didSet {
            backgroundImageView.layer.cornerRadius = Constants.videoCornerRadius
            backgroundImageView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        }
    }
    
    @IBOutlet private weak var descriptionBackground: UIView! {
        didSet {
            descriptionBackground.layer.cornerRadius = Constants.videoCornerRadius
            descriptionBackground.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            descriptionBackground.blurView.setup(style: .regular, alpha: 0.8).enable()
        }
    }
    
    @IBOutlet private weak var rulesButton: ScalingButton! {
        didSet{
            rulesButton.backgroundColor = UIColor.systemRed.withAlphaComponent(0.2)
            rulesButton.layer.cornerRadius = Constants.buttonCornerRadius
            rulesButton.addTarget(self, action: #selector(rulesButtonPressed(_:)), for: .touchUpInside)
        }
    }
    
    @IBOutlet private weak var blanksButton: ScalingButton! {
        didSet {
            blanksButton.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.2)
            blanksButton.layer.cornerRadius = Constants.buttonCornerRadius
            blanksButton.addTarget(self, action: #selector(blanksButtonPressed(_:)), for: .touchUpInside)
        }
    }
    
    @IBOutlet private weak var videoView: VideoView! {
        didSet {
            videoView.configureVideoView(parent: self)
            videoView.layer.cornerRadius = Constants.videoCornerRadius
        }
    }
        
    //MARK:- Lifecycle 
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareNavigationBar(title: homeGame.fullTitle, tintColor: .white)
        loadDetail()
    }
    
    @objc private func rulesButtonPressed(_ sender: UIButton) {
        openUrl(with: Constants.gameRulesPath, accentColor: sender.backgroundColor)
    }
    
    @objc private func blanksButtonPressed(_ sender: UIButton) {
        openUrl(with: homeGame.blanksPath, accentColor: sender.backgroundColor)
    }
    
    private func openUrl(with path: String?, accentColor: UIColor!) {
        guard let path = path else { return }
        var rulesUrlComps = NetworkService.shared.baseUrlComponents
        rulesUrlComps.path = path
        guard let url = rulesUrlComps.url else { return }
        openSafariVC(with: url, delegate: nil)
    }
    
    //MARK:- Load Details
    private func loadDetail() {
        NetworkService.shared.getHomeGame(by: homeGame.id) { (result) in
            switch result {
            case let .failure(error):
                print(error)
                self.showErrorConnectingToServerAlert()
            case let .success(gameDetailed):
                self.homeGame = gameDetailed
                self.updateUI()
            }
        }
    }
    
    //MARK:- Update UI
    private func updateUI() {
        videoView.configurePlayer(url: homeGame.videoUrl, shouldAutoPlay: false)
        videoView.imageView.loadImage(path: homeGame.frontImagePath)
        descriptionLabel.text = homeGame.description ?? "..."
    }
}
