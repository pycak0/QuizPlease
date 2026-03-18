//
//  PriceKind.swift
//  QuizPlease
//
//  Created by Русаков Владислав Андреевич on 11.03.2026.
//  Copyright © 2026 Владислав. All rights reserved.
//

import Foundation

/// Способы оплаты игры
enum PriceKind: Int, Decodable {

    /// Оплата с команды
    case team = 0

    /// Оплата с человека
    case person = 1

    /// Оплата со стола
    case table = 2
}
