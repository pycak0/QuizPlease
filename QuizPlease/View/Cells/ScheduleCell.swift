//
//MARK:  ScheduleCell.swift
//  QuizPlease
//
//  Created by Владислав on 30.07.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import UIKit

class ScheduleCell: UITableViewCell {
    static let reuseIdentifier = "ScheduleCell"
    static let nibName = "ScheduleCell"
    
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var titleBackgroundView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var scheduleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureViews()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        UIView.animate(withDuration: 0.1) { [weak self] in
            if highlighted {
                self?.cellView.transform = CGAffineTransform(scaleX: 0.96, y: 0.96)
            } else {
                self?.cellView.transform = .identity
            }
        }
    }
    
    private func configureViews() {
        cellView.layer.cornerRadius = 25
        titleBackgroundView.layer.cornerRadius = titleBackgroundView.frame.height / 2
        titleBackgroundView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner]
        scheduleLabel.layer.cornerRadius = scheduleLabel.frame.height / 2
    }
    
}
