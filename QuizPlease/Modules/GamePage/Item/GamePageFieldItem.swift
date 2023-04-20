//
//  GamePageFieldItem.swift
//  QuizPlease
//
//  Created by Владислав on 14.04.2023.
//  Copyright © 2023 Владислав. All rights reserved.
//

import UIKit

struct GamePageFieldItem {

    let kind: GamePageItemKind
    let title: String
    let placeholder: String
    let options: GamePageFieldOptions
    var bottomInset: CGFloat
    let fieldColor: UIColor
    let backgroundColor: UIColor
    let trimsUserInput: Bool

    let valueProvider: () -> String?
    let onValueChange: ((String) -> Void)?
    let onEndEditing: (() -> Void)?
    let showsOkButton: Bool
    let okButtonAction: (() -> Void)?

    private let canBeEdited: (() -> Bool)?
    private let swipeActions: [UIContextualAction]

    init(
        kind: GamePageItemKind,
        title: String,
        placeholder: String,
        options: GamePageFieldOptions,
        bottomInset: CGFloat = 0,
        fieldColor: UIColor = .clear,
        backgroundColor: UIColor = .systemGray6Adapted,
        trimsUserInput: Bool = true,
        valueProvider: @autoclosure @escaping () -> String?,
        onValueChange: ((String) -> Void)? = nil,
        onEndEditing: (() -> Void)? = nil,
        showsOkButton: Bool = false,
        okButtonAction: (() -> Void)? = nil,
        canBeEdited: (() -> Bool)? = nil,
        swipeActions: [UIContextualAction] = []
    ) {
        self.kind = kind
        self.title = title
        self.placeholder = placeholder
        self.options = options
        self.bottomInset = bottomInset
        self.fieldColor = fieldColor
        self.backgroundColor = backgroundColor
        self.trimsUserInput = trimsUserInput

        self.valueProvider = valueProvider
        self.onValueChange = onValueChange
        self.onEndEditing = onEndEditing

        self.showsOkButton = showsOkButton
        self.okButtonAction = okButtonAction

        self.canBeEdited = canBeEdited
        self.swipeActions = swipeActions
    }
}

// MARK: - GamePageItemProtocol

extension GamePageFieldItem: GamePageItemProtocol {

    func cellClass(with context: GamePageViewContext) -> GamePageCellProtocol.Type {
        GamePageFieldCell.self
    }

    func isEditable() -> Bool {
        canBeEdited?() ?? false
    }

    func trailingSwipeActions() -> [UIContextualAction] {
        swipeActions
    }
}
