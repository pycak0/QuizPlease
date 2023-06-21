//
//  GamePageCellProtocol.swift
//  QuizPlease
//
//  Created by Владислав on 10.04.2023.
//  Copyright © 2023 Владислав. All rights reserved.
//

import UIKit

/// Cell protocol for `GamePageView`
protocol GamePageCellProtocol: UITableViewCell {

    /// Configure cell with given item protocol.
    /// - Parameter item: An item implementing `GamePageItemProtocol`
    func configure(with item: GamePageItemProtocol)
}
