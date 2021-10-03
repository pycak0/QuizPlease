//
//  MainMenuItem.swift
//  QuizPlease
//
//  Created by Владислав on 03.08.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import Foundation
import CoreGraphics

// MARK: - Protocol
protocol MainMenuItemProtocol {
    var _kind: MainMenuItemKind { get }
    var identifier: String { get }
    var segueID: String { get }
    var title: String { get }
    var supplementaryText: String { get }
    var height: CGFloat { get }
}

// MARK: - Menu Item Struct
struct MainMenuItem: MainMenuItemProtocol {
    var _kind: MainMenuItemKind
    var identifier: String
    var segueID: String

    var title: String
    var supplementaryText: String
    var height: CGFloat
    
    init(_ kind: MainMenuItemKind) {
        _kind = kind
        identifier = kind.identifier
        segueID = kind.segueID
        title = kind.title
        supplementaryText = kind.supplementaryText
        height = kind.height
    }
}

// MARK: - MainMenuItem Kinds
enum MainMenuItemKind: Int, CaseIterable, MainMenuItemProtocol {
    var _kind: MainMenuItemKind { self }
    
    case schedule, profile, warmup, homeGame, shop, rating
    
    var identifier: String {
        switch self {
        case .schedule:     return ScheduleCell.identifier
        case .profile:      return MenuProfileCell.identifier
        case .warmup:       return WarmupCell.identifier
        case .homeGame:     return MenuHomeGameCell.identifier
        case .rating:       return MenuRatingCell.identifier
        case .shop:         return MenuShopCell.identifier
        }
    }
    
    var title: String {
        switch self {
        case .schedule:     return "Расписание"
        case .profile:      return "Личный кабинет"
        case .homeGame:     return "20 хоум игр ждут вас"
        case .warmup:       return "Разминка"
        case .shop:         return "Магазин"
        case .rating:       return "Рейтинг команд"
        }
    }
    
    var supplementaryText: String {
        switch self {
        case .schedule:     return "Игры в барах"
        case .profile:      return "100 баллов"
        case .homeGame:     return "Есть новые"
        case .warmup:       return "Размяться"
        case .shop:         return "больше"
        case .rating:       return "15. Ваша команда"
        }
    }
    
    var height: CGFloat {
        switch self {
        case .homeGame:     return 225
        case .shop:         return 228
        default:            return 200
        }
    }
    
    var segueID: String {
        switch self {
        case .schedule:     return "Show ScheduleVC"
        case .profile:      return "Show ProfileVC"
        case .homeGame:     return "Show HomeGamesListVC"
        case .warmup:       return "Show WarmUpVC"
        case .shop:         return "Show ShopVC"
        case .rating:       return "Show RatingVC"
        }
    }
}
