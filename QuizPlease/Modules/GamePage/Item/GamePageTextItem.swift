//
//  GamePageTextItem.swift
//  QuizPlease
//
//  Created by Владислав on 14.04.2023.
//  Copyright © 2023 Владислав. All rights reserved.
//

import UIKit

/// GamePage Text item
struct GamePageTextItem {

    /// Text of the item
    let text: String
    /// Text style
    let style: Style
    /// Text inset from the top
    let topInset: CGFloat
    /// Text inset from the bottom
    let bottomInset: CGFloat

    /// Text style
    enum Style {
        case title, subtitle

        var font: UIFont {
            switch self {
            case .title:
                return .gilroy(.bold, size: 28)
            case .subtitle:
                return .gilroy(.semibold, size: 16)
            }
        }

        var color: UIColor {
            switch self {
            case .title:
                return .labelAdapted
            case .subtitle:
                return .lightGray
            }
        }
    }
}

// MARK: - GamePageItemProtocol

extension GamePageTextItem: GamePageItemProtocol {

    func cellClass(with context: GamePageViewContext) -> AnyClass {
        GamePageTextCell.self
    }
}
