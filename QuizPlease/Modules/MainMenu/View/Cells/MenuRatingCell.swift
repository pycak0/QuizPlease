//
//  MenuRatingCell.swift
//  QuizPlease
//
//  Created by Владислав on 07.08.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import UIKit

class MenuRatingCell: UITableViewCell, MenuCellItemProtocol {
    static let identifier = "MenuRatingCell"

    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    weak var accessoryLabel: UILabel!

    @IBOutlet weak var ratingLabel: UILabel! {
        didSet {
            ratingLabel.layer.masksToBounds = true
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        configureViews()
    }

    func configureViews() {
        cellView.layer.cornerRadius = cellViewCornerRadius
        ratingLabel.layer.cornerRadius = ratingLabel.frame.height / 2
    }

    func configureCell(with model: MainMenuItemProtocol) {
        titleLabel.text = model.title
        // accessoryLabel.text = model.supplementaryText
    }

}
