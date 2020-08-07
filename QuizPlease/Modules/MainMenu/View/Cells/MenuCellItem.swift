//
//  MenuCellItem.swift
//  QuizPlease
//
//  Created by Владислав on 31.07.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import UIKit

protocol MenuCellItem: UITableViewCell {
    ///It is both a reuse identifier and a nib name
    static var identifier: String { get }

    var cellViewCornerRadius: CGFloat { get }
    
    var cellView: UIView! { get set }
    var titleLabel: UILabel! { get set }
    var accessoryLabel: UILabel! { get set }
    
    ///Should be called inside cell's `layoutSubviews()` method
    func configureViews()
    
    ///Should be called inside `tableView(_:cellForRowAt)` method
    func configureCell(with model: MenuItemProtocol)
    
}

extension MenuCellItem {
    var cellViewCornerRadius: CGFloat {
        25
    }
}
