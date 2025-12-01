//
//  GameRegistrationValidationResponseData.swift
//  QuizPlease
//
//  Created by Русаков Владислав Андреевич on 01.12.2025.
//  Copyright © 2025 Владислав. All rights reserved.
//

import Foundation

struct GameRegistrationValidationResponseData: Decodable {

    let success: Bool
    let errorMsg: String?
}
