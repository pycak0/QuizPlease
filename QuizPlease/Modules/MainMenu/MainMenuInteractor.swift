//
//  MainMenuInteractor.swift
//  QuizPlease
//
//  Created by Владислав on 03.08.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import Foundation

protocol MainMenuInteractorProtocol: class {
    func loadMenuItems(completion: @escaping (Result<[MenuItemProtocol]?, Error>) -> Void)
}

class MainMenuInteractor: MainMenuInteractorProtocol {
    func loadMenuItems(completion: @escaping (Result<[MenuItemProtocol]?, Error>) -> Void) {
        var items: [MenuItemProtocol] = []
        for i in 0..<MenuItemKind.allCases.count {
            items.append(MenuItemKind(rawValue: i)!)
        }
        completion(
//            .success([
//                MenuItem(title: "Расписание", supplementaryText: "Игры в барах", kind: .schedule),
//                MenuItem(title: "Личный кабинет", supplementaryText: "100 баллов", kind: .profile),
//                MenuItem(title: "Игры хоум", supplementaryText: "Играть", kind: .homeGame),
//                MenuItem(title: "Разминка", supplementaryText: "Перейти", kind: .warmup),
//                MenuItem(title: "Магазин", supplementaryText: "К покупкам", kind: .shop)
//            ])
            .success(items)
        )
    }
    
}
