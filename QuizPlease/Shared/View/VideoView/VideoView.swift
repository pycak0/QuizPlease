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

    @IBOutlet private var contentView: UIView!
    @IBOutlet private weak var playerView: UIView!
    @IBOutlet weak var imageView: UIImageView!

    private unowned var parent: UIViewController!
    private var playerVC = AVPlayerViewController()

    var url: URL?

    // MARK: - Public

    var showsPlaybackControls: Bool {
        get { playerVC.showsPlaybackControls }
        set { playerVC.showsPlaybackControls = newValue }
    }

    func play() {
        setCategoryPlayback()
        playerVC.player?.play()
    }

    func pause() {
        playerVC.player?.pause()
    }

    func stop() {
        pause()
        playerVC.player = nil
    }

    func configurePlayer(url: URL?, shouldAutoPlay: Bool = true) {
        guard let url = url else { return }
        playerVC.player = AVPlayer(url: url)
        setCategoryPlayback()
        if shouldAutoPlay {
            play()
        }
    }

    /// - parameter parent: a view controller to add AVPlayerViewController as child on it
    func configureVideoView(parent: UIViewController) {
//        guard parent != nil else { fatalError("VideoView must have `parent` property set") }

        playerVC.view.frame = playerView.bounds
        playerVC.videoGravity = .resizeAspectFill
        playerVC.view.layer.masksToBounds = true

        playerVC.view.backgroundColor = .black
        playerVC.showsPlaybackControls = true

        // MARK: - insert player into videoView
        parent.addChild(playerVC)
        playerVC.didMove(toParent: parent)
        playerView.addSubview(playerVC.view)
        playerView.backgroundColor = .clear
        playerVC.entersFullScreenWhenPlaybackBegins = false
    }

    // MARK: - Lifecycle

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
        self.parent = parent
        self.url = url
        configureVideoView(parent: parent)
        configurePlayer(url: url)
    }

    // MARK: - Private Methods

    private func xibSetup() {
        Bundle.main.loadNibNamed(VideoView.nibName, owner: self, options: nil)
        self.addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }

    private func setCategoryPlayback() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [])
        } catch {
            print(error)
        }
    }
}
