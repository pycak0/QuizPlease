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
    var number: String
    var price: Int
    
    private var videos_link: String?
    private var front_image: String?
    private var packages_link: String?
//    var cover: String
}

extension HomeGame {
    var videoUrl: URL? {
        let path = videos_link ?? ""
        var components = URLComponents(string: Globals.mainDomain)!
        components.path = path.pathProof
        return components.url
    }
    
    var frontImageUrl: URL? {
        var components = URLComponents(string: Globals.mainDomain)!
        components.path = (front_image ?? "").pathProof
        return components.url
    }
    
    var blanksPath: String {
        (packages_link ?? "").pathProof
    }
}
