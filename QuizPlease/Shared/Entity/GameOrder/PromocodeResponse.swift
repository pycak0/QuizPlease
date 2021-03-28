//
//  PromocodeResponse.swift
//  QuizPlease
//
//  Created by Владислав on 28.03.2021.
//  Copyright © 2021 Владислав. All rights reserved.
//

import Foundation

struct PromocodeResponse: Decodable {
    var isSuccess: Bool
    var message: String
    
    private enum CodingKeys: String, CodingKey {
        case isSuccess = "success"
        case message
    }
}
