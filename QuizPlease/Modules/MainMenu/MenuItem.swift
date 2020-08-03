//
//  MenuItem.swift
//  QuizPlease
//
//  Created by Владислав on 03.08.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import Foundation

struct MenuItem {
    var title: String
    var supplementaryText: String
    var itemKind: MenuItemKind
}

enum MenuItemKind: CaseIterable {
    case schedule, profile, homeGame, warmup, shop
    
    var segueID: String {
        switch self {
        case .schedule:     return "Show ScheduleVC"
        case .profile:      return "Show ProfileVC"
        case .homeGame:     return "Show HomeGameVC"
        case .warmup:       return "Show WarmUpVC"
        case .shop:         return "Show ShopVC"
        }
    }
}
