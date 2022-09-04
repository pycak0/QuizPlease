//
//  String+nonBreakingSpace.swift
//  QuizPlease
//
//  Created by Владислав on 05.09.2022.
//  Copyright © 2022 Владислав. All rights reserved.
//

import Foundation

extension String {

    /// Unicode 'No-Break Space' symbol (`U+00A0`)
    static var nonBreakingSpace: String {
        "\u{00a0}"
    }
}
