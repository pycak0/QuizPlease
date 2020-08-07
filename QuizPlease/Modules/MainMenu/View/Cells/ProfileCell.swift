//
//  ProfileCell.swift
//  QuizPlease
//
//  Created by Владислав on 07.08.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import UIKit

class ProfileCell: UITableViewCell, MenuCellItem {
    static let identifier = "ProfileCell"
    
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var accessoryLabel: UILabel!
    
    @IBOutlet weak var addGameLabel: UILabel!
    @IBOutlet weak var profileLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        configureViews()
    }
    
    @objc
    private func didPressAddGameLabel() {
        
    }
    
    func configureCell(with model: MenuItemProtocol) {
        cellView.layer.cornerRadius = cellViewCornerRadius
        titleLabel.text = model.title
        accessoryLabel.text = model.supplementaryText
    }
    
    func configureViews() {
        commentLabel.textColor = UIColor.black.withAlphaComponent(0.5)
        accessoryLabel.layer.cornerRadius = accessoryLabel.frame.height / 2
        
        addGameLabel.layer.cornerRadius = addGameLabel.frame.height / 2
        profileLabel.layer.cornerRadius = profileLabel.frame.height / 2
    }
    
}
