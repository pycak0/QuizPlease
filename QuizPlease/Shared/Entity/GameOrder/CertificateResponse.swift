//
//  CertificateResponse.swift
//  QuizPlease
//
//  Created by Владислав on 12.12.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import Foundation

enum CertificateDiscountType {
    case allTeamFree
    case numberOfPeopleForFree(_ number: Int)
    case none
}

struct CertificateResponse: Decodable {
    var success: Bool
    var message: String?
    private var type: Int?
}

extension CertificateResponse {
    var discountType: CertificateDiscountType {
        guard let type = type else {
            return .none
        }
        switch type {
        case 0:
            return .allTeamFree
        case 1...9:
            return .numberOfPeopleForFree(type)
        case 11...15:
            return .numberOfPeopleForFree(1)
        default:
            return .none
        }
    }
}
