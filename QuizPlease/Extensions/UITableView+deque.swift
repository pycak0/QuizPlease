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
    ///   - kind: Cell class
    ///   - indexPath: The index path specifying the location of the cell.
    ///   For more details, see ohter tableView `dequeueReusableCell` methods' documentation.
    /// - Returns: A specified `Kind` object that inherits `UITableViewCell`.
    /// If tableView could not create an object of given type, throws `fatalError`.
    func dequeueReusableCell<Kind: UITableViewCell>(
        _ kind: Kind.Type,
        for indexPath: IndexPath
    ) -> Kind {
        guard let cell = dequeueReusableCell(
            withIdentifier: "\(Kind.self)",
            for: indexPath
        ) as? Kind else {
            assertionFailure("❌ Invalid cell kind!")
            return Kind.init()
        }
        return cell
    }
}
