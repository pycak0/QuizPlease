//
//  MainMenuInteractor.swift
//  QuizPlease
//
//  Created by Владислав on 03.08.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import Foundation

protocol MainMenuInteractorProtocol: class {
    func loadMenuItems(completion: @escaping (Result<[MenuItem]?, Error>) -> Void)
}

class MainMenuInteractor: MainMenuInteractorProtocol {
    func loadMenuItems(completion: @escaping (Result<[MenuItem]?, Error>) -> Void) {
        completion(
            .success([
                MenuItem(title: "Расписание", supplementaryText: "Игры в барах", itemKind: .schedule),
                MenuItem(title: "Личный кабинет", supplementaryText: "100 баллов", itemKind: .profile),
                MenuItem(title: "Игры хоум", supplementaryText: "Играть", itemKind: .homeGame),
                MenuItem(title: "Разминка", supplementaryText: "Перейти", itemKind: .warmup),
                MenuItem(title: "Магазин", supplementaryText: "К покупкам", itemKind: .shop)
            ])
        )
    }
    
}
