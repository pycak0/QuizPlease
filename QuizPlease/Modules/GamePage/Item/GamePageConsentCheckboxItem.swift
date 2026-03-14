//
//  GamePageConsentCheckboxItem.swift
//  QuizPlease
//
//  Created on 15.03.2026.
//

import Foundation

/// GamePage consent checkbox item with tappable links
struct GamePageConsentCheckboxItem {

    /// item kind
    let kind: GamePageItemKind
    /// checkbox text
    let text: String
    /// tappable links within the text
    let links: [AgreementCheckboxView.Link]
    /// selection state provider
    let getIsSelected: () -> Bool
    /// selection change handler
    let onValueChange: ((Bool) -> Void)?
    /// link tap handler
    let onLinkTap: ((URL) -> Void)?
}

// MARK: - GamePageItemProtocol

extension GamePageConsentCheckboxItem: GamePageItemProtocol {

    func cellClass(with context: GamePageViewContext) -> GamePageCellProtocol.Type {
        GamePageConsentCheckboxCell.self
    }
}
