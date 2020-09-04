//
//  GameShortInfo.swift
//  QuizPlease
//
//  Created by Владислав on 04.09.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import Foundation

///Server response has a bunch of information given with the list of games but the field names are different from `GameInfo` model, so we store only game id here.
struct GameShortInfo: Decodable {
    var id: Int
}
