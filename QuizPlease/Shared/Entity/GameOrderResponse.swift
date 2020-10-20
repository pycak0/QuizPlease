//
//  GameOrderResponse.swift
//  QuizPlease
//
//  Created by Владислав on 17.10.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import Foundation

struct GameOrderResponse: Decodable {
    private var success: Int?
    var successMsg: String?
    var errorMsg: String?
    
    var isSuccess: Bool {
        return (success ?? 0) == 0 ? false : true
    }
}

