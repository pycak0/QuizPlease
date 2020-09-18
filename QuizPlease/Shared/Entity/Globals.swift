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
    
    // https://quizplease.ru/
    // https://staging.quizplease.ru:81/
    static let mainDomain = "https://quizplease.ru/"
    static let devDomain = "https://staging.quizplease.ru:81/"
    static var baseUrl: URLComponents {
        var urlComps = URLComponents(string: Globals.mainDomain)!
        urlComps.queryItems = []
        return urlComps
    }
    
    static var defaultCity: City = City(id: 9, title: "Москва")
}
