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
    let options: Options
    var bottomInset: CGFloat
    let fieldColor: UIColor
    let backgroundColor: UIColor

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
        options: GamePageFieldItem.Options,
        bottomInset: CGFloat = 0,
        valueProvider: @autoclosure @escaping () -> String?,
        fieldColor: UIColor = .clear,
        backgroundColor: UIColor = .systemGray6Adapted,
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

extension GamePageFieldItem {

    /// Field options
    struct Options {

        let contentType: UITextContentType?
        let keyboardType: UIKeyboardType
        let capitalizationType: UITextAutocapitalizationType

        init(
            contentType: UITextContentType? = nil,
            keyboardType: UIKeyboardType = .default,
            capitalizationType: UITextAutocapitalizationType = .none
        ) {
            self.contentType = contentType
            self.keyboardType = keyboardType
            self.capitalizationType = capitalizationType
        }

        var isPhoneMode: Bool {
            contentType == .telephoneNumber
        }
    }
}

extension GamePageFieldItem.Options {

    /// Preset for phone number
    static let phone = GamePageFieldItem.Options(
        contentType: .telephoneNumber,
        keyboardType: .phonePad
    )

    /// Preset for team field
    static let team = GamePageFieldItem.Options(
        contentType: .nickname,
        capitalizationType: .sentences
    )

    /// Preset for a basic generic field
    static let basic = GamePageFieldItem.Options(
        capitalizationType: .sentences
    )

    /// Preset for the captain name field
    static let captain = GamePageFieldItem.Options(
        contentType: .givenName,
        capitalizationType: .words
    )

    /// Preset for the email field
    static let email = GamePageFieldItem.Options(
        contentType: .emailAddress,
        keyboardType: .emailAddress,
        capitalizationType: .none
    )
}
