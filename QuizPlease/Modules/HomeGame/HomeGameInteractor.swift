//
//  HomeGameInteractor.swift
//  QuizPlease
//
//  Created by Владислав on 04.08.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import UIKit

protocol HomeGameInteractorProtocol {
    func loadHomeGames(completion: @escaping (Result<[HomeGame], NetworkServiceError>) -> Void)
}

class HomeGameInteractor: HomeGameInteractorProtocol {
    func loadHomeGames(completion: @escaping (Result<[HomeGame], NetworkServiceError>) -> Void) {
        NetworkService.shared.getHomeGames { (serverResult) in
            completion(serverResult)
        }
    }
}
