//
// MARK: ScheduleCell.swift
//  QuizPlease
//
//  Created by Владислав on 30.07.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import UIKit

final class ScheduleCell: UITableViewCell, MenuCellItemProtocol {

    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var accessoryImageView: UIImageView!
    // @IBOutlet weak var titleBackgroundView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var accessoryLabel: UILabel!

    override func layoutSubviews() {
        super.layoutSubviews()
        configureViews()
    }

    func configureCell(with model: MainMenuItemProtocol) {
        titleLabel.text = model.title
        accessoryLabel.text = model.supplementaryText
    }

    func configureViews() {
        cellView.layer.cornerRadius = cellViewCornerRadius
        // titleBackgroundView.layer.cornerRadius = titleBackgroundView.frame.height / 2
        // titleBackgroundView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner]

        titleLabel.layer.cornerRadius = titleLabel.frame.height / 2
    }
}
