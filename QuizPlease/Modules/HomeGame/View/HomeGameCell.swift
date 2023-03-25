//
//  HomeGameCell.swift
//  QuizPlease
//
//  Created by Владислав on 19.08.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import UIKit

class HomeGameCell: UICollectionViewCell {
    static let identifier = "HomeGameCell"

    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var gameNameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var playLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        configureViews()
    }

    private func configureViews() {
        layer.cornerRadius = 20
        cellView.layer.cornerRadius = 20
        backgroundImage.tintColor = .systemPurple
        backgroundImage.alpha = 0.2
        // cellView.backgroundColor = UIColor.systemPurple.withAlphaComponent(0.5)
        // cellView.addBlur(color: .systemPurple, style: .regular, alpha: 0.7)
        cellView.blurView.setup(style: .regular, alpha: 0.97).enable()
        cellView.blurView.backgroundColor = UIColor.ripePlum.withAlphaComponent(0.7)
        playLabel.layer.cornerRadius = playLabel.frame.height / 2
    }

    func configureCell(with game: HomeGame) {
        gameNameLabel.text = game.fullTitle
        timeLabel.text = game.duration

        let priceText: String = {
            if let price = game.price, price != 0 {
                return "\(price)"
            }
            return "Бесплатно"
        }()
        priceLabel.text = priceText
    }
}
