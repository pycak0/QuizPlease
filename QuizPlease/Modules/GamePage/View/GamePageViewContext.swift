//
//  GamePageViewContext.swift
//  QuizPlease
//
//  Created by Владислав on 10.04.2023.
//  Copyright © 2023 Владислав. All rights reserved.
//

import UIKit

/// Class containing the surrounding context of the GamePageView
final class GamePageViewContext {

    unowned let tableView: UITableView
    unowned let view: GamePageView

    /// Game page view context
    /// - Parameters:
    ///   - tableView: the table view
    ///   - view: the game page view
    init(tableView: UITableView, view: GamePageView) {
        self.tableView = tableView
        self.view = view
    }
}
