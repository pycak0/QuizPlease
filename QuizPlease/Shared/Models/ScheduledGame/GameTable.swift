//
//  GameTable.swift
//  QuizPlease
//
//  Created by Русаков Владислав Андреевич on 17.03.2026.
//  Copyright © 2026 Владислав. All rights reserved.
//

import Foundation

/// Стол для игры с типом оплаты «со стола»
struct GameTable: Decodable {
    let id: Int
    let name: String
    let price: Int
    let seats: Int
}
