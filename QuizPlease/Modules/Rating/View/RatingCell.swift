//
//  MenuRatingCell.swift
//  QuizPlease
//
//  Created by Владислав on 17.08.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import UIKit

class RatingCell: UITableViewCell, TableCellProtocol {
    static let identifier = "RatingCell"
    
    @IBOutlet weak var teamNameLabel: UILabel!
    @IBOutlet weak var gamesPlayedLabel: UILabel!
    @IBOutlet weak var pointsScoredLabel: UILabel!
    
    func configure(with team: String, games: Int, points: Int) {
        teamNameLabel.text = team
        gamesPlayedLabel.text = "\(games) игр"
        pointsScoredLabel.text = points.string(withAssociatedMaleWord: "балл")
    }
    
}
