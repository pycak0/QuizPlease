//
//  GamePageTeamCountItem.swift
//  QuizPlease
//
//  Created by Владислав on 14.04.2023.
//  Copyright © 2023 Владислав. All rights reserved.
//

import UIKit

/// GamePage team count item
struct GamePageTeamCountItem {

    /// Item kind
    let kind: GamePageItemKind
    /// Count picker title. If `nil`, title will be hidden
    let title: String?
    /// Picker unselected color
    let pickerColor: UIColor
    /// Background color if the picker cell
    let backgroundColor: UIColor
    /// Minimal counter value
    let getMinCount: () -> Int
    /// Maximal counter value
    let getMaxCount: () -> Int
    /// Provides currently selected team count
    let getSelectedTeamCount: () -> Int
    /// Team count change handler
    let changeHandler: ((Int) -> Void)?

    init(
        kind: GamePageItemKind,
        title: String?,
        pickerColor: UIColor,
        backgroundColor: UIColor,
        getMinCount: @autoclosure @escaping () -> Int,
        getMaxCount: @autoclosure @escaping () -> Int,
        getSelectedTeamCount: @autoclosure @escaping () -> Int,
        changeHandler: ((Int) -> Void)?
    ) {
        self.kind = kind
        self.title = title
        self.pickerColor = pickerColor
        self.backgroundColor = backgroundColor
        self.getMinCount = getMinCount
        self.getMaxCount = getMaxCount
        self.getSelectedTeamCount = getSelectedTeamCount
        self.changeHandler = changeHandler
    }
}

// MARK: - GamePageItemProtocol

extension GamePageTeamCountItem: GamePageItemProtocol {

    func cellClass(with context: GamePageViewContext) -> GamePageCellProtocol.Type {
        GamePageTeamCountCell.self
    }
}
