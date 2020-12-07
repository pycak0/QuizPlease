//
//  ProfileSampleCell.swift
//  QuizPlease
//
//  Created by Владислав on 07.12.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import UIKit

class ProfileSampleCell: UITableViewCell, TableCellProtocol {
    static let identifier = "ProfileSampleCell"
    
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var sampleTextLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureCell()
    }
    
    private func configureCell() {
        cellView.layer.cornerRadius = 20
        cellView.layer.borderWidth = 4
        cellView.layer.borderColor = UIColor.themeGray.cgColor
    }
    
    func configure(with sampleText: String) {
        sampleTextLabel.text = sampleText
    }
    
}
