//
//  GameOrderResponse.swift
//  QuizPlease
//
//  Created by Владислав on 17.10.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import Foundation

struct GameOrderResponse: Decodable {
    private var success: AnyValue?
    var successMsg: String?
    var errorMsg: String?
    
    var isSuccess: Bool {
        if let number = success?.value() as? Int {
            return number == 0 ? false : true
        }
        else if let isSuccess = success?.value() as? Bool {
            return isSuccess
        }
        else {
            return false
        }
    }
}

