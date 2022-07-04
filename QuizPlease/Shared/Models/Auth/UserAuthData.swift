//
//  UserAuthData.swift
//  QuizPlease
//
//  Created by Владислав on 03.10.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import Foundation

struct UserAuthData: Codable {
    var phone: String

    /// sms code
    var code: String?
    /// firebase id
    var device_id: String = ""
}
