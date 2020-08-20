//
//  ProfileCell.swift
//  QuizPlease
//
//  Created by Владислав on 20.08.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import UIKit

class ProfileCell: UITableViewCell, TableCellProtocol {
    static let identifier = "ProfileCell"
    
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var gameNameLabel: UILabel!
    @IBOutlet weak var gameNumberLabel: UILabel!
    @IBOutlet weak var prizeImageView: UIImageView!
    @IBOutlet weak var placeLabel: UILabel!
    @IBOutlet weak var teamNameLabel: UILabel!
    @IBOutlet weak var pointsScoredLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    private func configureCell() {
        cellView.layer.cornerRadius = 20
        cellView.layer.borderWidth = 4
        cellView.layer.borderColor = UIColor.themeGray.cgColor
        pointsScoredLabel.layer.cornerRadius = pointsScoredLabel.bounds.height / 2
    }
    
    func configure(game: GameInfo, team: Team, place: Int, pointsScored: Int) {
        gameNameLabel.text = game.name
        gameNumberLabel.text = "#\(game.gameNumber)"
        teamNameLabel.text = team.name
        placeLabel.text = "\(place) место"
        pointsScoredLabel.text = "+ \(pointsScored.string(withAssociatedMaleWord: "балл"))"
        
        prizeImageView.isHidden = place > 3
    }
    
}
