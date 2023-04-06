//
//  Configuration+ConvenientProperties.swift
//  QuizPlease
//
//  Created by Владислав on 07.04.2023.
//  Copyright © 2023 Владислав. All rights reserved.
//

import Foundation

public extension Configuration {

    /// Convenient property to check for Debug
    var isDebug: Bool {
        self == .debug
    }

    /// Convenient property to check for Production
    var isProduction: Bool {
        self == .production
    }
}
