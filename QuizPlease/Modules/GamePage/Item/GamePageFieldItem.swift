//
//  GamePageFieldItem.swift
//  QuizPlease
//
//  Created by Владислав on 14.04.2023.
//  Copyright © 2023 Владислав. All rights reserved.
//

import UIKit

struct GamePageFieldItem {

    let title: String
    let placeholder: String
    let options: Options
    var bottomInset: CGFloat
    let fieldColor: UIColor
    let backgroundColor: UIColor

    let valueProvider: () -> String?
    let onValueChange: ((String) -> Void)?

    init(
        title: String,
        placeholder: String,
        options: GamePageFieldItem.Options,
        bottomInset: CGFloat = 0,
        valueProvider: @autoclosure @escaping () -> String?,
        fieldColor: UIColor = .clear,
        backgroundColor: UIColor = .systemGray6Adapted,
        onValueChange: ((String) -> Void)? = nil
    ) {
        self.title = title
        self.placeholder = placeholder
        self.options = options
        self.bottomInset = bottomInset
        self.fieldColor = fieldColor
        self.backgroundColor = backgroundColor

        self.valueProvider = valueProvider
        self.onValueChange = onValueChange
    }
}

// MARK: - GamePageItemProtocol

extension GamePageFieldItem: GamePageItemProtocol {

    func cellClass(with context: GamePageViewContext) -> AnyClass {
        GamePageFieldCell.self
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
        capitalizationType: .words
    )
}
