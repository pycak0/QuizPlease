//
//  SavedAuthInfo.swift
//  QuizPlease
//
//  Created by Владислав on 11.10.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import Foundation

struct SavedAuthInfo: Codable {
    var accessToken: String?
    var refreshToken: String?
    var expireDate: Date?
    
    init(authInfoResponse: AuthInfoResponse) {
        accessToken = authInfoResponse.access_token
        refreshToken = authInfoResponse.refresh_token
        if let seconds = authInfoResponse.expired_at {
            expireDate = Date().addingTimeInterval(seconds)
        }
    }
}
