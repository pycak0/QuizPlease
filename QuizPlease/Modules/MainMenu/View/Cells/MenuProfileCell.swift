//
//  MenuProfileCell.swift
//  QuizPlease
//
//  Created by Владислав on 07.08.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import UIKit

protocol MenuProfileCellDelegate: class {
    func addGameButtonPressed(in cell: MenuProfileCell)
}

class MenuProfileCell: UITableViewCell, MenuCellItemProtocol {
    static let identifier = "MenuProfileCell"
    
    weak var delegate: MenuProfileCellDelegate?
    
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var accessoryLabel: UILabel!
    @IBOutlet weak var addGameButton: UIButton!
    @IBOutlet weak var profileLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!

    @IBAction func addGameButtonPressed(_ sender: Any) {
        delegate?.addGameButtonPressed(in: self)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureViews()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        accessoryLabel.layer.cornerRadius = accessoryLabel.frame.height / 2
        
        addGameButton.layer.cornerRadius = addGameButton.frame.height / 2
        profileLabel.layer.cornerRadius = profileLabel.frame.height / 2
        
        cellView.layer.cornerRadius = cellViewCornerRadius
    }
    
    func setUserPoints(_ points: Int) {
        accessoryLabel.text = points.string(withAssociatedMaleWord: "балл")
        accessoryLabel.isHidden = false
    }
    
    func hideUserPoints() {
        accessoryLabel.isHidden = true
        accessoryLabel.text = ""
    }
    
    func configureCell(with model: MenuItemProtocol) {
        titleLabel.text = model.title
        //accessoryLabel.text = model.supplementaryText
    }
    
    func configureViews() {
        accessoryLabel.isHidden = true
        commentLabel.textColor = UIColor.black.withAlphaComponent(0.5)
        
        cellView.addGradient(colors: [.yellow, .lightOrange],
                             frame: CGRect(origin: contentView.bounds.origin,
                                           size: CGSize(width: UIScreen.main.bounds.width,
                                                        height: contentView.bounds.height)), insertAt: 0)
        //gradientView.addGradient(colors: [.yellow, .lightOrange], frame: contentView.bounds)
    }
    
}
