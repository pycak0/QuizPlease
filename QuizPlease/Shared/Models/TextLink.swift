//
//  TextLink.swift
//  QuizPlease
//
//  Created by Владислав on 25.03.2023.
//  Copyright © 2023 Владислав. All rights reserved.
//

/// A model characterizing a link in a text view with action
struct TextLink {

    /// Link text
    let text: String
    /// Action on tap
    let action: () -> Void
}
