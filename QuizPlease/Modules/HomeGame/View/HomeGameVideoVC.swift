//
//MARK:  HomeGameVideoVC.swift
//  QuizPlease
//
//  Created by Владислав on 24.08.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import UIKit

class HomeGameVideoVC: UIViewController {
    
    @IBOutlet weak var descriptionBackground: UIView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var rulesButton: ScalingButton!
    @IBOutlet weak var blanksButton: ScalingButton!
    @IBOutlet weak var videoView: VideoView!
    
    var homeGame: HomeGame!
    
    //MARK:- Lifecycle 
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareNavigationBar(title: homeGame.title, tintColor: .white)

        configureViews()
        updateUI()
        loadDetail()
    }
    
    @IBAction func rulesButtonPressed(_ sender: Any) {
        //openUrl(with: homeGame.rulesPath)
    }
    
    @IBAction func blanksButtonPressed(_ sender: Any) {
        openUrl(with: homeGame.blanksPath)
    }
    
    private func openUrl(with path: String) {
        var rulesUrlComps = Globals.baseUrl
        rulesUrlComps.path = path
        if let url = rulesUrlComps.url, UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
    
    
    //MARK:- Configure Views
    private func configureViews() {
        videoView.parent = self
        videoView.configureVideoView()
        descriptionBackground.blurView.setup(style: .regular, alpha: 0.8).enable()
        //descriptionBackground.addBlur(color: .systemPurple, style: blurStyle, alpha: 0.7)
        
        rulesButton.backgroundColor = UIColor.systemRed.withAlphaComponent(0.2)
        blanksButton.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.2)
        
        let buttonRadius: CGFloat = 20
        let videoRadius: CGFloat = 30
        blanksButton.layer.cornerRadius = buttonRadius
        rulesButton.layer.cornerRadius = buttonRadius
        
        videoView.layer.cornerRadius = videoRadius
        descriptionBackground.layer.cornerRadius = videoRadius
        descriptionBackground.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
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
        videoView.configurePlayer(url: homeGame.videoUrl)
        videoView.imageView.loadImage(url: homeGame.frontImageUrl)
        
        descriptionLabel.text = homeGame.description ?? "..."
        
    }

}
