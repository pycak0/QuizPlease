//
//  RegisterResponse.swift
//  QuizPlease
//
//  Created by Владислав on 03.10.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import Foundation

struct RegisterResponse: Decodable {
    var status: Int?

    var message: String
}
