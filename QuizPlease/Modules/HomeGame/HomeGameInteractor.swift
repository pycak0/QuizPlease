//
//  HomeGameInteractor.swift
//  QuizPlease
//
//  Created by Владислав on 04.08.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import Foundation

protocol HomeGameInteractorProtocol {
    func loadHomeGames(completion: @escaping (Result<[HomeGame], SessionError>) -> Void)
}

class HomeGameInteractor: HomeGameInteractorProtocol {
    func loadHomeGames(completion: @escaping (Result<[HomeGame], SessionError>) -> Void) {
        NetworkService.shared.getHomeGames { (serverResult) in
            completion(serverResult)
        }
    }
}
