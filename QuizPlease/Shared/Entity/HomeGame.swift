//
//  HomeGame.swift
//  QuizPlease
//
//  Created by Владислав on 24.08.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import Foundation

struct HomeGame {
    var id: Int
    var title: String
    var description: String
    var duration: String
    var videos_link: String
    var cover: String
    var number: String
    var price: String
}

extension HomeGame {
    var url: URL? {
        return URL(string: videos_link)
    }
}
