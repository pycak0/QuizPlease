//
//  HomeGame.swift
//  QuizPlease
//
//  Created by Владислав on 24.08.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import Foundation

struct HomeGame: Decodable {
    var id: Int
    var title: String
    var description: String?
    var duration: String
    private var videos_link: String?
    private var front_image: String?
//    var cover: String
    var number: String
    var price: Int
}

extension HomeGame {
    var videoUrl: URL? {
        var path = videos_link ?? ""
        if !path.hasPrefix("/") {
            path = "/" + path
        }
        var components = URLComponents(string: Globals.mainDomain)!
        components.path = path
        return components.url
    }
    
    var frontImageUrl: URL? {
        var path = front_image ?? ""
        if !path.hasPrefix("/") {
            path = "/" + path
        }
        var components = URLComponents(string: Globals.mainDomain)!
        components.path = path
        return components.url
    }
}
