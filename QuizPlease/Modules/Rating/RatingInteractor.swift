//
//  RatingInteractor.swift
//  QuizPlease
//
//  Created by Владислав on 04.08.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import Foundation

protocol RatingInteractorProtocol {
    func loadRating(with filter: RatingFilter, page: Int, completion: @escaping (Result<[RatingItem], SessionError>) -> Void)
}

class RatingInteractor: RatingInteractorProtocol {
    func loadRating(with filter: RatingFilter, page: Int, completion: @escaping (Result<[RatingItem], SessionError>) -> Void) {
        NetworkService.shared.getRating(cityId: filter.city.id, teamName: filter.teamName, league: filter.league.rawValue, ratingScope: filter.scope.rawValue, page: page) { (serverResult) in
            completion(serverResult)
        }
        
    }
    
}
