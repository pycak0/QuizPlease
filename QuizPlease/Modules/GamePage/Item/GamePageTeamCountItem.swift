//
//  GamePageTeamCountItem.swift
//  QuizPlease
//
//  Created by Владислав on 14.04.2023.
//  Copyright © 2023 Владислав. All rights reserved.
//

import Foundation

/// GamePage team count item
struct GamePageTeamCountItem {

    /// Provides currently selected team count
    let getSelectedTeamCount: () -> Int
    /// Team count change handler
    let changeHandler: ((Int) -> Void)?

    init(
        getSelectedTeamCount: @autoclosure @escaping () -> Int,
        changeHandler: ((Int) -> Void)?
    ) {
        self.getSelectedTeamCount = getSelectedTeamCount
        self.changeHandler = changeHandler
    }
}

// MARK: - GamePageItemProtocol

extension GamePageTeamCountItem: GamePageItemProtocol {

    func cellClass(with context: GamePageViewContext) -> AnyClass {
        GamePageTeamCountCell.self
    }
}
