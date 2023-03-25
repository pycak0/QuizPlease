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
    var price: Int?

    private var videos_link: String?
    private var front_image: String?
    private var packages_link: String?
//    var cover: String

    init() {
        id = 0
        title = ""
        description = "hello world"
        duration = ""
        number = ""
        price = 0
    }

}

extension HomeGame {
    var videoUrl: URL? {
        let path = videos_link ?? ""
        var components = URLComponents(string: NetworkConfiguration.prod.host)!
        components.path = path.pathProof
        return components.url
    }

    var frontImagePath: String? {
        return front_image?.pathProof
    }

    var blanksPath: String? {
        packages_link?.pathProof
    }

    /// A title of home game containing its `title` and `number` properties separated by a whitespace
    var fullTitle: String {
        return "\(title.trimmingCharacters(in: .whitespaces)) \(number)"
    }
}
