//
//  UserRegisterData.swift
//  QuizPlease
//
//  Created by Владислав on 04.10.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import Foundation

struct UserRegisterData: Encodable {
    var phone: String
    
    var city_id: String? = nil
}
