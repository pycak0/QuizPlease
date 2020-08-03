//
//MARK:  ScheduleCell.swift
//  QuizPlease
//
//  Created by Владислав on 30.07.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import UIKit

class ScheduleCell: UITableViewCell, MenuCellItem {
    static let reuseIdentifier = "ScheduleCell"
    static let nibName = "ScheduleCell"
    
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var titleBackgroundView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var accessoryLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureViews()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    private func configureViews() {
        cellView.layer.cornerRadius = 25
        titleBackgroundView.layer.cornerRadius = titleBackgroundView.frame.height / 2
        titleBackgroundView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner]
        accessoryLabel.layer.cornerRadius = accessoryLabel.frame.height / 2
    }
    
}
