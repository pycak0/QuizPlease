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
            let kind = MenuItemKind(rawValue: i)!
            items.append(MenuItem(kind))
        }
        
        completion(.success(items))
    }
    
}
