//
//  ProfileCell.swift
//  QuizPlease
//
//  Created by Владислав on 20.08.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import UIKit

private enum Constants {
    static let verticalInsets: CGFloat = 10
}

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

    @IBOutlet private weak var backgroundImageTopConstraint: NSLayoutConstraint!
    @IBOutlet private weak var backgroundImageView: UIImageView! {
        didSet {
            backgroundImageTopConstraint.constant = Constants.verticalInsets
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
        place: String?,
        teamName: String?,
        dateAndTime: String?
    ) {
        gameNameLabel.text = gameName
        gameNumberLabel.text = gameNumber
        placeLabel.text = place
        teamNameLabel.text = teamName
        pointsScoredLabel.text = dateAndTime

        placeLabel.isHidden = place == nil
        teamNameLabel.isHidden = teamName == nil
        prizeImageView.isHidden = true
        pointsScoredLabel.isHidden = dateAndTime == nil
    }
}
