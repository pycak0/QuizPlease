//
//  MenuProfileCell.swift
//  QuizPlease
//
//  Created by Владислав on 07.08.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import UIKit

class MenuProfileCell: UITableViewCell, MenuCellItemProtocol {
    static let identifier = "MenuProfileCell"
    
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var accessoryLabel: UILabel!
    
    @IBOutlet weak var addGameLabel: UILabel!
    @IBOutlet weak var profileLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        addGameLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didPressAddGameLabel)))
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        configureViews()
    }
    
    @objc
    private func didPressAddGameLabel() {
        print("add game label pressed")
    }
    
    func configureCell(with model: MenuItemProtocol) {
        titleLabel.text = model.title
        //accessoryLabel.text = model.supplementaryText
    }
    
    func configureViews() {
        commentLabel.textColor = UIColor.black.withAlphaComponent(0.5)
        accessoryLabel.layer.cornerRadius = accessoryLabel.frame.height / 2
        
        addGameLabel.layer.cornerRadius = addGameLabel.frame.height / 2
        profileLabel.layer.cornerRadius = profileLabel.frame.height / 2
        
        cellView.layer.cornerRadius = cellViewCornerRadius
        cellView.addGradient(colors: [.yellow, .lightOrange],
                             frame: CGRect(origin: contentView.bounds.origin,
                                           size: CGSize(width: UIScreen.main.bounds.width,
                                                        height: contentView.bounds.height)), insertAt: 0)
        //gradientView.addGradient(colors: [.yellow, .lightOrange], frame: contentView.bounds)
    }
    
}
