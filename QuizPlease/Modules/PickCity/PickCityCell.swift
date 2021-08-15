//
//  PickCityCell.swift
//  QuizPlease
//
//  Created by Владислав on 15.08.2021.
//  Copyright © 2021 Владислав. All rights reserved.
//

import UIKit

class PickCityCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        textLabel?.font = .gilroy(.semibold, size: 20)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
