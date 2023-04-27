//
//  VersionResponse.swift
//  QuizPlease
//
//  Created by Владислав on 28.04.2023.
//  Copyright © 2023 Владислав. All rights reserved.
//

import Foundation

/// Version data structure from backend
struct VersionData: Decodable {

    /// Possible values are expecteed to be 1 or 0
    let forceUpdate: Int
    /// Possible values are expecteed to be 1 or 0
    let preferablyUpdate: Int
}

/// Version response to a backend request
struct VersionResponse: Decodable {

    let success: Bool
    let message: String?
    let update: VersionData?
}
