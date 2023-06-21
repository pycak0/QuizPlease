//
//  GamePageTextItem.swift
//  QuizPlease
//
//  Created by Владислав on 14.04.2023.
//  Copyright © 2023 Владислав. All rights reserved.
//

import UIKit

extension GamePageTextItem {

    static func title(
        _ text: String,
        topInset: CGFloat = 16,
        bottomInset: CGFloat = 8
    ) -> GamePageTextItem {
        GamePageTextItem(
            kind: .registrationHeader,
            text: text,
            topInset: topInset,
            bottomInset: bottomInset,
            backgroundColor: .systemGray6Adapted,
            font: .gilroy(.bold, size: 28),
            textColor: .labelAdapted
        )
    }

    static func subtitle(
        _ text: String,
        topInset: CGFloat = 0,
        bottomInset: CGFloat = 10
    ) -> GamePageTextItem {
        GamePageTextItem(
            kind: .registrationHeader,
            text: text,
            topInset: topInset,
            bottomInset: bottomInset,
            backgroundColor: .systemGray6Adapted,
            font: .gilroy(.bold, size: 16),
            textColor: .lightGray
        )
    }
}

/// GamePage Text item
struct GamePageTextItem {

    let kind: GamePageItemKind
    /// Text of the item
    let text: String
    /// Text inset from the top
    let topInset: CGFloat
    /// Text inset from the bottom
    let bottomInset: CGFloat
    /// Cell background color
    let backgroundColor: UIColor
    /// Text font
    let font: UIFont
    /// Text color
    let textColor: UIColor
    /// Text alignment
    let textAlignment: NSTextAlignment

    init(
        kind: GamePageItemKind,
        text: String,
        topInset: CGFloat,
        bottomInset: CGFloat,
        backgroundColor: UIColor,
        font: UIFont,
        textColor: UIColor,
        textAlignment: NSTextAlignment = .left
    ) {
        self.kind = kind
        self.text = text
        self.topInset = topInset
        self.bottomInset = bottomInset
        self.backgroundColor = backgroundColor
        self.font = font
        self.textColor = textColor
        self.textAlignment = textAlignment
    }
}

// MARK: - GamePageItemProtocol

extension GamePageTextItem: GamePageItemProtocol {

    func cellClass(with context: GamePageViewContext) -> GamePageCellProtocol.Type {
        GamePageTextCell.self
    }
}
