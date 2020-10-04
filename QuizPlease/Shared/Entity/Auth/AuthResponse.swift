//
//  AuthResponse.swift
//  QuizPlease
//
//  Created by Владислав on 03.10.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import Foundation

struct AuthResponse: Decodable {
    var access_token: String
    var expired_at: Int
    var refresh_token: String
}
