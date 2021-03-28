//
//  GameOrderResponse.swift
//  QuizPlease
//
//  Created by Владислав on 17.10.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import Foundation

enum GameOrderStatus: String, Decodable {
    case pending, canceled, succeeded, undefined
}

struct GameOrderResponse: Decodable {
    private var redirect: Bool?
    private var success: AnyValue?
    
    var link: URL?
    private var status: AnyValue?
    
    private var successMsg: String?
    private var errorMsg: String?
    
    var successMessage: String? {
        successMsg?.removingAngleBrackets()
    }
    
    var errorMessage: String? {
        errorMsg?.removingAngleBrackets()
    }
    
    var isSuccess: Bool {
        if let number = success?.value() as? Int {
            return number == 1
        }
        if let isSuccess = success?.value() as? Bool {
            return isSuccess
        }
        return false
    }
    
    var paymentStatus: GameOrderStatus {
        if let string = success?.value() as? String {
            return GameOrderStatus(rawValue: string) ?? .undefined
        }
        return .undefined
    }
    
    var isSuccessfullyRegistered: Bool {
        if let statusNumber = status?.value() as? Int {
            return statusNumber == 1
        }
        if let statusString = status?.value() as? String {
            if let paymentStatus = GameOrderStatus(rawValue: statusString), paymentStatus == .canceled {
                return false
            }
            return statusString == "1"
        }
        return isSuccess
    }
    
    var shouldRedirect: Bool {
        redirect ?? false
    }
}

