//
//  ServerResponse.swift
//  QuizPlease
//
//  Created by Владислав on 27.08.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import Foundation

struct ServerResponse<Data: Decodable>: Decodable {
    var data: Data
}
