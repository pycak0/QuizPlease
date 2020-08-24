//
//  HomeGameInteractor.swift
//  QuizPlease
//
//  Created by Владислав on 04.08.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import Foundation

protocol HomeGameInteractorProtocol {
    func loadHomeGames(completion: @escaping (Result<[HomeGame], Error>) -> Void)
}

class HomeGameInteractor: HomeGameInteractorProtocol {
    func loadHomeGames(completion: @escaping (Result<[HomeGame], Error>) -> Void) {
        var games = [HomeGame]()
        for i in 0...6 {
            games.append(
                HomeGame(id: i, title: "Title\(i)", description: "Description\(i)", duration: "3\(i) мин", videos_link: "link", cover: "cover", number: "\(i + 1)", price: "Бесплатно")
            )
        }
        
        completion(.success(games))
    }
}
