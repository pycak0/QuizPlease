//
//MARK:  HomeGameVideoVC.swift
//  QuizPlease
//
//  Created by Владислав on 24.08.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import UIKit
import SafariServices

class HomeGameVideoVC: UIViewController {
    
    @IBOutlet private weak var backgroundImageView: UIImageView!
    @IBOutlet private weak var descriptionBackground: UIView!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var rulesButton: ScalingButton!
    @IBOutlet private weak var blanksButton: ScalingButton!
    @IBOutlet private weak var videoView: VideoView!
    
    var homeGame: HomeGame! = HomeGame()
    
    //MARK:- Lifecycle 
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareNavigationBar(title: homeGame.fullTitle, tintColor: .white)
        configureViews()
        loadDetail()
    }
    
    @IBAction private func rulesButtonPressed(_ sender: UIButton) {
        openUrl(with: homeGame.rulesPath, accentColor: sender.backgroundColor)
    }
    
    @IBAction private func blanksButtonPressed(_ sender: UIButton) {
        openUrl(with: homeGame.blanksPath, accentColor: sender.backgroundColor)
    }
    
    private func openUrl(with path: String?, accentColor: UIColor!) {
        guard let path = path else { return }
        var rulesUrlComps = NetworkService.shared.baseUrlComponents
        rulesUrlComps.path = path
        guard let url = rulesUrlComps.url else { return }
        openSafariVC(with: url, delegate: self)
    }
    
    //MARK:- Configure Views
    private func configureViews() {
        videoView.configureVideoView(parent: self)
        descriptionBackground.blurView.setup(style: .regular, alpha: 0.8).enable()
        //descriptionBackground.addBlur(color: .systemPurple, style: blurStyle, alpha: 0.7)
        
        rulesButton.backgroundColor = UIColor.systemRed.withAlphaComponent(0.2)
        blanksButton.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.2)
        
        let buttonCornerRadius: CGFloat = 20
        let videoCornerRadius: CGFloat = 30
        blanksButton.layer.cornerRadius = buttonCornerRadius
        rulesButton.layer.cornerRadius = buttonCornerRadius
        
        videoView.layer.cornerRadius = videoCornerRadius
        descriptionBackground.layer.cornerRadius = videoCornerRadius
        backgroundImageView.layer.cornerRadius = videoCornerRadius
        descriptionBackground.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        backgroundImageView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
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

//MARK:- Safari VC Delegate
extension HomeGameVideoVC: SFSafariViewControllerDelegate {}
