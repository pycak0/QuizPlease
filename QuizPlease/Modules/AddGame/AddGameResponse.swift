//
//  AddGameResponse.swift
//  QuizPlease
//
//  Created by Владислав on 19.05.2021.
//  Copyright © 2021 Владислав. All rights reserved.
//

import Foundation

struct AddGameResponse: Decodable {
    let message: String?
    let status: Int?
}
