//
//  NetworkConfiguration.swift
//  QuizPlease
//
//  Created by Владислав on 12.04.2021.
//  Copyright © 2021 Владислав. All rights reserved.
//

import Foundation

public enum NetworkConfiguration: CustomStringConvertible {
    case staging, production

    public static let standard: NetworkConfiguration = {
        switch Configuration.current {
        case .debug, .staging:
            return .staging
        case .production:
            return .production
        }
    }()

    var host: String {
        switch self {
        case .staging:
            return "https://mobile-api.dev.quizplease.ru/"
        case .production:
            return "https://quizplease.ru/"
        }
    }

    private var identifier: String {
        switch self {
        case .staging: return "staging"
        case .production: return "production"
        }
    }

    public var description: String {
        """
        NetworkConfiguration: {
            kind: \(identifier)
            host: "\(host)"
        }
        """
    }
}
