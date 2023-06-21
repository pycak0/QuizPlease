//
//  AudioView.swift
//  QuizPlease
//
//  Created by Владислав on 12.11.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import UIKit
import AVKit

// MARK: - Delegate Protocol
protocol AudioViewDelegate: AnyObject {

    /// - parameter progress: the value is in [0, 1] bounds
    func audioView(_ audioView: AudioView, didUpdateProgress progress: Double)

    func audioView(_ audioView: AudioView, didFailToConfigurePlayerWithError error: Error)

    func didFinishPlayingAudio(in audioView: AudioView)
}

final class AudioView: UIView {
    static let nibName = "\(AudioView.self)"

    // MARK: - Outlets

    @IBOutlet private var contentView: UIView!
    @IBOutlet private weak var playPauseButton: UIButton!

    @IBOutlet private weak var progressView: UIProgressView! {
        didSet {
            progressView.setProgress(0, animated: false)
            progressView.trackTintColor = UIColor.white.withAlphaComponent(0.2)
        }
    }

    private var player: AVAudioPlayer?

    private var updater: CADisplayLink?

    // MARK: - Public

    weak var delegate: AudioViewDelegate?

    @IBInspectable
    var playImage: UIImage? = UIImage(named: "play")

    @IBInspectable
    var pauseImage: UIImage? = UIImage(named: "pause")

    private var shouldBePlaying = false

    var isPlaying: Bool {
        player?.isPlaying ?? false
    }

    func play() {
        player?.play()
        playPauseButton.setImage(pauseImage, for: .normal)
        setupTracking()
        shouldBePlaying = true
    }

    func pause() {
        player?.pause()
        playPauseButton.setImage(playImage, for: .normal)
        stopTracking()
        shouldBePlaying = false
    }

    func stop() {
        pause()
        player?.stop()
        player = nil
    }

    func configure(with url: URL?) {
        guard let url = url else {
            let error = NSError(domain: "Invalid or nil URL passed to AudioView's player", code: -99999)
            delegate?.audioView(self, didFailToConfigurePlayerWithError: error)
            return
        }

        DispatchQueue.global().async {
            let data = try? Data(contentsOf: url)

            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                if data != nil {
                    self.configurePlayer(with: data!)
                    if self.shouldBePlaying {
                        self.play()
                    }
                } else {
                    self.stopTracking()
                    let error = NSError(domain: "Error downloading sound data", code: -99999)
                    self.delegate?.audioView(self, didFailToConfigurePlayerWithError: error)
                }
            }
        }

    }

    // MARK: - Private Methods

    @IBAction
    private func playPauseButtonPressed(_ sender: UIButton) {
        if isPlaying {
            pause()
        } else {
            play()
        }
    }

    private func configurePlayer(with data: Data) {
        do {
            player = try AVAudioPlayer(data: data)
            player?.delegate = self

            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [])
            try AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)

            delegate?.audioView(self, didUpdateProgress: 0)

        } catch {
            stopTracking()
            delegate?.audioView(self, didFailToConfigurePlayerWithError: error)
        }
    }

    private func setupTracking() {
        updater = CADisplayLink(target: self, selector: #selector(updateProgress))
        updater?.add(to: RunLoop.main, forMode: .common)
    }

    private func stopTracking() {
        updater?.invalidate()
        updater = nil
    }

    @objc
    private func updateProgress() {
        guard let player = player else { return }
        let progress = player.currentTime / player.duration
        progressView.setProgress(Float(progress), animated: false)

        delegate?.audioView(self, didUpdateProgress: progress)
    }

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        xibSetup()
    }

    convenience init(url: URL?) {
        self.init()
        configure(with: url)
    }

    private func xibSetup() {
        Bundle.main.loadNibNamed(AudioView.nibName, owner: self, options: nil)
        self.addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }

    deinit {
        stopTracking()
    }

}

// MARK: - AVAudioPlayerDelegate
extension AudioView: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        pause()
        // progressView.setProgress(1, animated: true)
        delegate?.didFinishPlayingAudio(in: self)
    }
}
