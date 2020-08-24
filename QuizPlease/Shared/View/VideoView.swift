//
//  VideoView.swift
//  QuizPlease
//
//  Created by Владислав on 24.08.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import UIKit
import AVKit

class VideoView: UIView {
    static let nibName = "VideoView"
    
    @IBOutlet var contentView: UIView!
    private var playerVC = AVPlayerViewController()
    var url: URL?

    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        xibSetup()
    }
    
    convenience init(parent: UIViewController, url: URL?) {
        self.init()
        self.url = url
        configureVideoView(parent: parent)
        configurePlayer(url: url)
    }
    
    private func xibSetup() {
        Bundle.main.loadNibNamed(VideoView.nibName, owner: self, options: nil)
        self.addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
    
    func configureVideoView(parent: UIViewController) {
        playerVC.view.frame = contentView.bounds
        playerVC.videoGravity = .resizeAspectFill
        playerVC.view.layer.masksToBounds = true
        
        playerVC.view.backgroundColor = .black
        playerVC.showsPlaybackControls = true
        
        //MARK:- insert player into videoView
        parent.addChild(playerVC)
        playerVC.didMove(toParent: parent)
        contentView.addSubview(playerVC.view)
        contentView.backgroundColor = .clear
        playerVC.entersFullScreenWhenPlaybackBegins = false
    }
    
    func configurePlayer(url: URL?) {
        guard let url = url else { return }
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [])
        } catch {
            print(error)
        }
        
        playerVC.player = AVPlayer(url: url)
        
    }
    
}
