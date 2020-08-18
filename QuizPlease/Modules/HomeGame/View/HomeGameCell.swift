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
        
    }
    
    //func configureCell
    
}
