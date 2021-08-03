//
//  ProfileSampleCell.swift
//  QuizPlease
//
//  Created by Владислав on 07.12.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import UIKit

class ProfileSampleCell: UITableViewCell, IdentifiableType {
    static let identifier = "\(ProfileSampleCell.self)"
    
    @IBOutlet weak var sampleTextLabel: UILabel!
    @IBOutlet weak var cellView: UIView! {
        didSet {
            cellView.layer.cornerRadius = 20
            cellView.layer.borderWidth = 4
            cellView.layer.borderColor = UIColor.systemGray6Adapted.cgColor
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        cellView.layer.borderColor = UIColor.systemGray6Adapted.cgColor
    }
    
    func configure(with sampleText: String) {
        sampleTextLabel.text = sampleText
    }
}
