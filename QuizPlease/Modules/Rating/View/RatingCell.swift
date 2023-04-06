//
//  MenuRatingCell.swift
//  QuizPlease
//
//  Created by Владислав on 17.08.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import UIKit

final class RatingCell: UITableViewCell, IdentifiableType {

    @IBOutlet private weak var teamNameLabel: UILabel!
    @IBOutlet private weak var gamesPlayedLabel: UILabel!
    @IBOutlet private weak var pointsScoredLabel: UILabel!
    @IBOutlet private weak var teamImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        configureViews()
    }

    private func configureViews() {
        let selectedView = UIView()
        selectedView.alpha = 0.1
        selectedView.backgroundColor = UIColor.black
        selectedBackgroundView = selectedView
    }

    func configure(with team: String, games: Int, points: Int, imagePath: String?) {
        teamNameLabel.text = team
        gamesPlayedLabel.text = games.string(withAssociatedFirstCaseWord: "игра", changingCase: .nominative)
        pointsScoredLabel.text = points.string(withAssociatedMaleWord: "балл")
        teamImageView.loadImage(using: .production, path: imagePath)
    }
}
