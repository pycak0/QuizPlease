//
//  ScheduleInteractor.swift
//  QuizPlease
//
//  Created by Владислав on 04.08.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import Foundation

protocol ScheduleInteractorProtocol: class {
    func loadSchedule(completion: @escaping (Result<[GameInfo]?, Error>) -> Void)
}

class ScheduleInteractor: ScheduleInteractorProtocol {
    func loadSchedule(completion: @escaping (Result<[GameInfo]?, Error>) -> Void) {
        var games = [GameInfo]()
        for i in 0...3 {
            let place = Place(name: "Place\(i)", address: "Address\(i)", longitude: 37.617635, latitude: 55.755814)
            games.append(GameInfo(gameNumber: i+1, name: "Game\(i)", place: place, time: "11:0\(i)", price: Decimal(1000 * i), annotation: "Annotation \(i)"))
        }
        completion(.success(games))
    }
}
