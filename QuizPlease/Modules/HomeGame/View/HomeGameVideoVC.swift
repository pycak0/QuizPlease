//
//  HomeGameVideoVC.swift
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareNavigationBar(title: homeGame.title, tintColor: .white)

        configureViews()
    }
    
    private func configureViews() {
        descriptionBackground.blurView.setup(style: .regular, alpha: 0.8).enable()
        descriptionBackground.addBlur(color: .systemPurple, style: blurStyle, alpha: 0.7)
        
        videoView.configureVideoView(parent: self)
        videoView.configurePlayer(url: homeGame.url)
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

}
