//
//  PushSubscribeResponse.swift
//  QuizPlease
//
//  Created by Владислав on 17.10.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import Foundation

struct PushSubscribeResponse: Decodable {
    var message: PushSubscribeType
}

enum PushSubscribeType: String, Decodable {
    case subscribe, unsubscribe
}
