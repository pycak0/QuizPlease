//
//  MenuItem.swift
//  QuizPlease
//
//  Created by Владислав on 03.08.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import Foundation
import CoreGraphics

protocol MenuItemProtocol {
    var identifier: String { get }
    var title: String { get }
    var supplementaryText: String { get }
    var height: CGFloat { get }
    var _kind: MenuItemKind { get }
}

//struct MenuItem: MenuItemProtocol {
//    var title: String
//    var supplementaryText: String
//    var _kind: MenuItemKind
//
//    var height: CGFloat {
//        switch kind {
//        case .schedule:     return 180
//        case .profile:      return 180
//        case .homeGame:     return 180
//        case .warmup:       return 180
//        case .shop:         return 180
//        }
//    }
//}

enum MenuItemKind: Int, CaseIterable, MenuItemProtocol {
    var _kind: MenuItemKind { self }
    
    case schedule, profile, warmup, homeGame, shop
    
    var identifier: String {
        switch self {
        case .schedule:     return ScheduleCell.identifier
        case .profile:      return ProfileCell.identifier
        case .warmup:       return WarmupCell.identifier
        case .homeGame:     return HomeGameCell.identifier
        default:            return ScheduleCell.identifier
        }
    }
    
    var title: String {
        switch self {
        case .schedule:     return "Расписание"
        case .profile:      return "Личный кабинет"
        case .homeGame:     return "20 хоум игр ждут вас"
        case .warmup:       return "Ежедневная разминка"
        case .shop:         return "Магазин"
        }
    }
    
    var supplementaryText: String {
        switch self {
        case .schedule:     return "Игры в барах"
        case .profile:      return "100 баллов"
        case .homeGame:     return "Есть новые"
        case .warmup:       return "Перейти"
        case .shop:         return "К покупкам"
        }
    }
    
    var height: CGFloat {
        switch self {
        case .schedule:     return 200
        case .profile:      return 200
        case .homeGame:     return 245
        case .warmup:       return 200
        case .shop:         return 200
        }
    }
    
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
