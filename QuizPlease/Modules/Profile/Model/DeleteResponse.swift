//
//  DeleteResponse.swift
//  QuizPlease
//
//  Created by Владислав on 24.08.2022.
//  Copyright © 2022 Владислав. All rights reserved.
//

import Foundation

struct DeleteResponse: Decodable {

    let isSuccess: Bool

    private enum CodingKeys: String, CodingKey {
        case isSuccess = "success"
    }
}
