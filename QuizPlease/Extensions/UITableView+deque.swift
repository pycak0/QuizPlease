//
//  UITableView+deque.swift
//  QuizPlease
//
//  Created by Владислав on 03.07.2022.
//  Copyright © 2022 Владислав. All rights reserved.
//

import UIKit

extension UITableView {

    /// Dequeues a reusable cell object located by its class name.
    ///
    /// - Parameters:
    ///   - cellClass: Cell class
    ///   - indexPath: The index path specifying the location of the cell.
    ///   For more details, see ohter tableView `dequeueReusableCell` methods' documentation.
    /// - Returns: A specified `CellClass` object that inherits `UITableViewCell`.
    /// If tableView could not create an object of given type, throws `fatalError`.
    func dequeueReusableCell<CellClass: UITableViewCell>(
        _ cellClass: CellClass.Type,
        for indexPath: IndexPath
    ) -> CellClass {
        guard let cell = dequeueReusableCell(
            withIdentifier: "\(CellClass.self)",
            for: indexPath
        ) as? CellClass else {
            assertionFailure("❌ Invalid cell kind!")
            return CellClass.init()
        }
        return cell
    }
}
