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
        gamesPlayedLabel.text = games.string(withAssociatedFirstCaseWord: "игра")
        //if let points = Int(points) {
            pointsScoredLabel.text = points.string(withAssociatedMaleWord: "балл")
       // }
        teamImageView.loadImageFromMainDomain(path: imagePath, placeholderImage: UIImage(named: "pixelGuyHatAndPlate"))
    }
    
}
