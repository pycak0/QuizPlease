//
//  Configuration.swift
//  QuizPlease
//
//  Created by Владислав on 07.04.2023.
//  Copyright © 2023 Владислав. All rights reserved.
//

import Foundation

/// App configuration
public enum Configuration: String {

    /// Development configuration
    case debug
    /// Testing configuration
    case staging
    /// Release configuration
    case production

    /// Сonfiguration in which the App is currently running
    public static let current: Configuration = {
        guard let rawValue = Bundle.main.infoDictionary?["Configuration"] as? String else {
            fatalError("No Configuration Found")
        }

        guard let configuration = Configuration(rawValue: rawValue.lowercased()) else {
            fatalError("Invalid Configuration")
        }

        return configuration
    }()
}
