//
//  GamePageRegisterButtonItem.swift
//  QuizPlease
//
//  Created by Русаков Владислав Андреевич on 11.04.2023.
//  Copyright © 2023 Владислав. All rights reserved.
//

import UIKit

/// GamePage item for a small register button at the top
struct GamePageRegisterButtonItem {

    /// Background color of the button
    let color: UIColor
    /// Title of the button
    let title: String
    /// An option to enable / disable button
    let isEnabled: Bool
    /// Button tap handler
    let tapAction: (() -> Void)?
}

// MARK: - GamePageItemProtocol

extension GamePageRegisterButtonItem: GamePageItemProtocol {

    func cellClass(with context: GamePageViewContext) -> AnyClass {
        GamePageRegisterButtonCell.self
    }
}
