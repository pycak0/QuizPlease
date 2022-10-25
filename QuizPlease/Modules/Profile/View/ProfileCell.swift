//
//  ProfileCell.swift
//  QuizPlease
//
//  Created by Владислав on 20.08.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import UIKit

final class ProfileCell: UITableViewCell, IdentifiableType {

    @IBOutlet private weak var gameNameLabel: UILabel!
    @IBOutlet private weak var gameNumberLabel: UILabel!
    @IBOutlet private weak var prizeImageView: UIImageView!
    @IBOutlet private weak var placeLabel: UILabel!
    @IBOutlet private weak var teamNameLabel: UILabel!
    @IBOutlet private weak var pointsScoredLabel: PaddingLabel!

    @IBOutlet private weak var cellView: UIView! {
        didSet {
            cellView.layer.cornerRadius = 20
            cellView.layer.borderWidth = 4
            cellView.layer.borderColor = UIColor.systemGray6Adapted.cgColor
        }
    }

    @IBOutlet private weak var backgroundImageView: UIImageView! {
        didSet {
            backgroundImageView.image = UIImage(named: "profile.game.background")
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        pointsScoredLabel.layer.cornerRadius = pointsScoredLabel.bounds.height / 2
        cellView.layer.borderColor = UIColor.systemGray6Adapted.cgColor
    }

    func configure(
        gameName: String,
        gameNumber: String,
        teamName: String,
        place: String?,
        pointsScoredText: String?
    ) {
        gameNameLabel.text = gameName
        gameNumberLabel.text = gameNumber
        teamNameLabel.text = teamName

        pointsScoredLabel.isHidden = pointsScoredText == nil
        if let text = pointsScoredText {
            pointsScoredLabel.text = text
        }

        if let placeStr = place {
            placeLabel.text = "\(placeStr) место"
            let number = Double(placeStr) ?? 99
            prizeImageView.isHidden = number > 3
        } else {
            placeLabel.isHidden = true
            prizeImageView.isHidden = true
        }
    }
}
