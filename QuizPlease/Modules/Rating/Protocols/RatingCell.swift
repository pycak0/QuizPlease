//
//  RatingCell.swift
//  QuizPlease
//
//  Created by Владислав on 27.04.2023.
//  Copyright © 2023 Владислав. All rights reserved.
//

import UIKit

protocol RatingCell: UITableViewCell {

    func configure(with item: RatingItem)
}
