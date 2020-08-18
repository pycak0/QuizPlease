//
//  MenuItem.swift
//  QuizPlease
//
//  Created by Владислав on 03.08.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import Foundation
import CoreGraphics

//MARK:- Protocol
protocol MenuItemProtocol {
    var _kind: MenuItemKind { get }
    var identifier: String { get }
    var segueID: String { get }
    var title: String { get }
    var supplementaryText: String { get }
    var height: CGFloat { get }
}

//MARK:- Menu Item Struct
struct MenuItem: MenuItemProtocol {
    var _kind: MenuItemKind
    var identifier: String
    var segueID: String

    var title: String
    var supplementaryText: String
    var height: CGFloat
    
    init(_ kind: MenuItemKind) {
        _kind = kind
        identifier = kind.identifier
        segueID = kind.segueID
        title = kind.title
        supplementaryText = kind.supplementaryText
        height = kind.height
    }
}

//MARK:- MenuItem Kinds
enum MenuItemKind: Int, CaseIterable, MenuItemProtocol {
    var _kind: MenuItemKind { self }
    
    case schedule, profile, warmup, homeGame, shop, rating
    
    var identifier: String {
        switch self {
        case .schedule:     return ScheduleCell.identifier
        case .profile:      return ProfileCell.identifier
        case .warmup:       return WarmupCell.identifier
        case .homeGame:     return MenuHomeGameCell.identifier
        case .rating:       return MenuRatingCell.identifier
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
        case .rating:       return "Рейтинг команд"
        }
    }
    
    var supplementaryText: String {
        switch self {
        case .schedule:     return "Игры в барах"
        case .profile:      return "100 баллов"
        case .homeGame:     return "Есть новые"
        case .warmup:       return "Перейти"
        case .shop:         return "К покупкам"
        case .rating:       return "15. Ваша команда"
        }
    }
    
    var height: CGFloat {
        switch self {
        case .homeGame:     return 245
        default:            return 200
        }
    }
    
    var segueID: String {
        switch self {
        case .schedule:     return "Show ScheduleVC"
        case .profile:      return "Show ProfileVC"
        case .homeGame:     return "Show HomeGameVC"
        case .warmup:       return "Show WarmUpVC"
        case .shop:         return "Show ShopVC"
        case .rating:       return "Show RatingVC"
        }
    }
}
