//
//  GamePageLaunchOptions.swift
//  QuizPlease
//
//  Created by Русаков Владислав Андреевич on 17.04.2023.
//  Copyright © 2023 Владислав. All rights reserved.
//

import Foundation

/// Presentation options for a GamePage
struct GamePageLaunchOptions {

    /// Game identifier
    let gameId: Int
    /// Should scroll to Registration section
    let shouldScrollToRegistration: Bool
}
