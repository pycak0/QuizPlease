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
    case stagingRating, productionRating

    public static let standard: NetworkConfiguration = {
        switch Configuration.current {
        case .debug, .staging:
            return .staging
        case .production:
            return .production
        }
    }()

    public static let rating: NetworkConfiguration = {
        switch Configuration.current {
        case .debug, .staging:
            return .stagingRating
        case .production:
            return .productionRating
        }
    }()

    var host: String {
        switch self {
        case .staging:
            return "https://mobile.qpdv.ru/"
        case .production:
            return "https://mobile.qpdv.ru/"
        case .stagingRating:
            return "https://rating-api.dev.quizplease.ru/"
        case .productionRating:
            return "https://rating-api.quizplease.ru/"
        }
    }

    private var identifier: String {
        switch self {
        case .staging: return "staging"
        case .production: return "production"
        case .stagingRating: return "stagingRating"
        case .productionRating: return "productionRating"
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
