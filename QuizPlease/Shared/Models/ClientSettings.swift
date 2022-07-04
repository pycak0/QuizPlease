//
//  ClientSettings.swift
//  QuizPlease
//
//  Created by Владислав on 12.04.2021.
//  Copyright © 2021 Владислав. All rights reserved.
//

import Foundation

struct ClientSettings: Codable {
    private let show_account: Int
    private let show_shop: Int

    var isProfileEnabled: Bool { show_account == 1 }
    var isShopEnabled: Bool { show_shop == 1 }
}
