//
//  MenuHomeGameCell.swift
//  QuizPlease
//
//  Created by Владислав on 07.08.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import UIKit

final class MenuHomeGameCell: UITableViewCell, MenuCellItemProtocol {

    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var accessoryLabel: UILabel!
    @IBOutlet weak var newGamesLabel: UILabel! {
        didSet {
            // сейчас плашка всегда спрятана
            newGamesLabel.layer.masksToBounds = true
            newGamesLabel.isHidden = true
        }
    }

    @IBOutlet weak var playLabel: UILabel! {
        didSet {
            playLabel.layer.masksToBounds = true
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        configureViews()
    }

    func configureViews() {
        cellView.layer.cornerRadius = cellViewCornerRadius
        newGamesLabel.layer.cornerRadius = newGamesLabel.frame.height / 2
        playLabel.layer.cornerRadius = playLabel.frame.height / 2
    }

    func configureCell(with model: MainMenuItemProtocol) {
        titleLabel.text = model.title
        accessoryLabel.text = model.supplementaryText
    }
}
