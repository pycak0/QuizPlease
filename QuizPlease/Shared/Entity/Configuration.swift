//
//  Configuration.swift
//  QuizPlease
//
//  Created by Владислав on 12.04.2021.
//  Copyright © 2021 Владислав. All rights reserved.
//

import Foundation

enum Configuration {
    case dev, prod
    
    var host: String {
        switch self {
        case .dev:
            return "https://staging.quizplease.ru:81/"
        case .prod:
            return "https://quizplease.ru/"
        }
    }
}
