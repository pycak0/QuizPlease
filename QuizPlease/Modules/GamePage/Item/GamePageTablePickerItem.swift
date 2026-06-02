//
//  GamePageTablePickerItem.swift
//  QuizPlease
//
//  Created by Русаков Владислав Андреевич on 17.03.2026.
//  Copyright © 2026 Владислав. All rights reserved.
//

import UIKit

/// GamePage item for selecting a table (for «оплата со стола» pricing)
struct GamePageTablePickerItem {

    /// Item kind
    let kind: GamePageItemKind
    /// Picker title
    let title: String
    /// Available tables
    let tables: [GameTable]
    /// Picker unselected color
    let pickerColor: UIColor
    /// Background color of the picker cell
    let backgroundColor: UIColor
    /// Provides currently selected table index
    let getSelectedIndex: () -> Int
    /// Table selection change handler (passes selected index)
    let changeHandler: ((Int) -> Void)?

    init(
        kind: GamePageItemKind,
        title: String,
        tables: [GameTable],
        pickerColor: UIColor,
        backgroundColor: UIColor,
        getSelectedIndex: @autoclosure @escaping () -> Int,
        changeHandler: ((Int) -> Void)?
    ) {
        self.kind = kind
        self.title = title
        self.tables = tables
        self.pickerColor = pickerColor
        self.backgroundColor = backgroundColor
        self.getSelectedIndex = getSelectedIndex
        self.changeHandler = changeHandler
    }
}

// MARK: - GamePageItemProtocol

extension GamePageTablePickerItem: GamePageItemProtocol {

    func cellClass(with context: GamePageViewContext) -> GamePageCellProtocol.Type {
        GamePageTeamCountCell.self
    }
}
