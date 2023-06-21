//
//  GamePageFieldOptions.swift
//  QuizPlease
//
//  Created by Русаков Владислав Андреевич on 19.04.2023.
//  Copyright © 2023 Владислав. All rights reserved.
//

import UIKit

/// Field options
struct GamePageFieldOptions {

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

extension GamePageFieldOptions {

    /// Preset for phone number
    static let phone = GamePageFieldOptions(
        contentType: .telephoneNumber,
        keyboardType: .phonePad
    )

    /// Preset for team field
    static let team = GamePageFieldOptions(
        contentType: .nickname,
        capitalizationType: .sentences
    )

    /// Preset for a basic generic field
    /// with default keyboard, unspecified content type and auto-capitalization by sentence
    static let basic = GamePageFieldOptions(
        capitalizationType: .sentences
    )

    /// Preset for the captain name field
    static let captain = GamePageFieldOptions(
        contentType: .givenName,
        capitalizationType: .words
    )

    /// Preset for the email field
    static let email = GamePageFieldOptions(
        contentType: .emailAddress,
        keyboardType: .emailAddress,
        capitalizationType: .none
    )
}
