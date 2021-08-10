//
//  NetworkConfiguration.swift
//  QuizPlease
//
//  Created by Владислав on 12.04.2021.
//  Copyright © 2021 Владислав. All rights reserved.
//

import Foundation

public enum NetworkConfiguration: CustomStringConvertible {
    case dev, prod
    
    public static let standard: NetworkConfiguration = .dev
    
    var host: String {
        switch self {
        case .dev:
            return "https://staging.quizplease.ru:81/"
        case .prod:
            return "https://quizplease.ru/"
        }
    }
    
    private var identifier: String {
        switch self {
        case .dev: return "dev"
        case .prod: return "prod"
        }
    }
    
    public var description: String {
        """
        NetworkConfiguration: {
            value: \(identifier)
            host: "\(host)"
        }
        """
    }
}
