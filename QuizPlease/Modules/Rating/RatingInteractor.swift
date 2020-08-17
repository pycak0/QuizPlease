//
//  RatingInteractor.swift
//  QuizPlease
//
//  Created by Владислав on 04.08.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import Foundation

protocol RatingInteractorProtocol {
    func loadRating(completion: @escaping (Result<[Team], Error>) -> Void)
}

class RatingInteractor: RatingInteractorProtocol {
    func loadRating(completion: @escaping (Result<[Team], Error>) -> Void) {
        var teams = [Team]()
        let amount = 15
        for i in 0...amount {
            teams.append(Team(name: "Name \(i)", games: amount - i, points: 10 * amount - i))
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            completion(.success(teams))
        }
        
    }
    
}
