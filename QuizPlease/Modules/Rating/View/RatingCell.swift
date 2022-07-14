//
//  MenuRatingCell.swift
//  QuizPlease
//
//  Created by Владислав on 17.08.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import UIKit

class RatingCell: UITableViewCell, IdentifiableType {
    static let identifier = "\(RatingCell.self)"

    @IBOutlet weak var teamNameLabel: UILabel!
    @IBOutlet weak var gamesPlayedLabel: UILabel!
    @IBOutlet weak var pointsScoredLabel: UILabel!
    @IBOutlet weak var teamImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        configureViews()
    }

    private func configureViews() {
        let selectedView = UIView()
        selectedView.alpha = 0.1
        selectedView.backgroundColor = UIColor.black//.withAlphaComponent(0.7)
        selectedBackgroundView = selectedView
    }

    func configure(with team: String, games: Int, points: Int, imagePath: String?) {
        teamNameLabel.text = team
        gamesPlayedLabel.text = games.string(withAssociatedFirstCaseWord: "игра", changingCase: .nominative)
        // if let points = Int(points) {
            pointsScoredLabel.text = points.string(withAssociatedMaleWord: "балл")
       // }
        teamImageView.loadImage(using: .prod, path: imagePath, placeholderImage: UIImage(named: "pixelGuyHatAndPlate"))
    }

}
