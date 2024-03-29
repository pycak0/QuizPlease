//
//  GOCPeopleNumberCell.swift
//  QuizPlease
//
//  Created by Владислав on 20.09.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import UIKit

/// GOC - GameOrderCompletion Number Cell
final class GOCPeopleNumberCell: UITableViewCell {

    @IBOutlet weak var countPicker: CountPickerView! {
        didSet {
            let font: UIFont = .gilroy(.semibold, size: 16)
            countPicker.isUserInteractionEnabled = false
            countPicker.titleLabel.font = font
            countPicker.buttonsTitleFont = font
            countPicker.buttonsCornerRadius = 15
        }
    }

    func setNumber(_ number: Int) {
        countPicker.setSelectedButton(at: number - countPicker.startCount, animated: false)
    }
}
