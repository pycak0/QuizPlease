//
//  MenuHomeGameCell.swift
//  QuizPlease
//
//  Created by Владислав on 07.08.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import UIKit

class MenuHomeGameCell: UITableViewCell, MenuCellItemProtocol {
    static let identifier = "MenuHomeGameCell"
    
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var accessoryLabel: UILabel!
    
    @IBOutlet weak var playLabel: UILabel!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        configureViews()
    }
    
    func configureViews() {
        cellView.layer.cornerRadius = cellViewCornerRadius
        accessoryLabel.layer.cornerRadius = accessoryLabel.frame.height / 2
        playLabel.layer.cornerRadius = playLabel.frame.height / 2
    }
    
    func configureCell(with model: MenuItemProtocol) {
        titleLabel.text = model.title
        accessoryLabel.text = model.supplementaryText
    }
    
}
