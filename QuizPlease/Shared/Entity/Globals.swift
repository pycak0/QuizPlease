//
//  Globals.swift
//  QuizPlease
//
//  Created by Владислав on 27.08.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import Foundation

class Globals {
    private init() {}
    
    static let domain = "https://staging.quizplease.ru:81/"
    static let baseUrl = URLComponents(string: Globals.domain)!
}
