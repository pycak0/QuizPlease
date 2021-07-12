//
//  ProfileCell.swift
//  QuizPlease
//
//  Created by Владислав on 20.08.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import UIKit

class ProfileCell: UITableViewCell, IdentifiableType {
    static let identifier = "\(ProfileCell.self)"
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var gameNameLabel: UILabel!
    @IBOutlet weak var gameNumberLabel: UILabel!
    @IBOutlet weak var prizeImageView: UIImageView!
    @IBOutlet weak var placeLabel: UILabel!
    @IBOutlet weak var teamNameLabel: UILabel!
    @IBOutlet weak var pointsScoredLabel: PaddingLabel!
    @IBOutlet weak var cellView: UIView! {
        didSet {
            cellView.layer.cornerRadius = 20
            cellView.layer.borderWidth = 4
            cellView.layer.borderColor = UIColor.systemGray6Adapted.cgColor
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
