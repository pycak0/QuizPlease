//
//  ScheduleInteractor.swift
//  QuizPlease
//
//  Created by Владислав on 04.08.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import Foundation

protocol ScheduleInteractorProtocol: class {
    func loadSchedule(filter: ScheduleFilter, completion: @escaping (Result<[GameInfo], SessionError>) -> Void)
    func loadDetailInfo(for gameId: Int, completion: @escaping (GameInfo?) -> Void)
    
    func openInMaps(placeName: String, withLongitutde lon: Double, andLatitude lat: Double)
    func openInMaps(place: Place)
    
    func getSubscribeStatus(gameId: String, completion: @escaping (_ isSubscribe: Bool?) -> Void)
}

class ScheduleInteractor: ScheduleInteractorProtocol {
    func loadSchedule(filter: ScheduleFilter, completion: @escaping (Result<[GameInfo], SessionError>) -> Void) {
        NetworkService.shared.getSchedule(with: filter) { (serverResult) in
            switch serverResult {
            case let .failure(error):
                completion(.failure(error))
            case let .success(gamesList):
                let gamesInfo: [GameInfo] = gamesList.map { GameInfo(id: $0.id) }
                completion(.success(gamesInfo))
            }
        }
    }
    
    func loadDetailInfo(for gameId: Int, completion: @escaping (GameInfo?) -> Void) {
        NetworkService.shared.getGameInfo(by: gameId) { (result) in
            switch result {
            case let .failure(error):
                print(error)
                completion(nil)
            case let .success(gameInfo):
                var fullInfo = gameInfo
                fullInfo.id = gameId
                completion(fullInfo)
            }
        }
    }
    
    func openInMaps(placeName: String, withLongitutde lon: Double, andLatitude lat: Double) {
        MapService.openMap(for: placeName, withLongitude: lon, andLatitude: lat)
    }
    
    func openInMaps(place: Place) {
        MapService.openMap(for: place.title!, withAddress: place.fullAddress)
    }
    
    func getSubscribeStatus(gameId: String, completion: @escaping (Bool?) -> Void) {
        NetworkService.shared.subscribePushOnGame(with: gameId, completion: completion)
    }
    
}
