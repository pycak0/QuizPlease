//
//  MenuCellItem.swift
//  QuizPlease
//
//  Created by Владислав on 31.07.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import UIKit

protocol MenuCellItem {
    static var reuseIdentifier: String { get }
    static var nibName: String { get }
    
    var cellView: UIView! { get set }
    var titleLabel: UILabel! { get set }
    var accessoryLabel: UILabel! { get set }
}
