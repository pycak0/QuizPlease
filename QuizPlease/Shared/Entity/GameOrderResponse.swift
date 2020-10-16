//
//  GameOrderResponse.swift
//  QuizPlease
//
//  Created by Владислав on 17.10.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import Foundation

struct GameOrderResponse: Decodable {
    var success: Bool?
    var successMsg: String?
    var errorMsg: String?
}
