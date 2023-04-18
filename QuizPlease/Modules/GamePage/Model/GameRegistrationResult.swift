//
//  GameRegistrationResult.swift
//  QuizPlease
//
//  Created by Русаков Владислав Андреевич on 18.04.2023.
//  Copyright © 2023 Владислав. All rights reserved.
//

import Foundation

struct GameRegistrationResult {

    struct Options {
        let gameInfo: GameInfo
        let teamCount: Int
    }

    let isSuccess: Bool
    let message: String?
    let options: Options
}
