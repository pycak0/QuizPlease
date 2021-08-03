//
//  ScheduleInteractor.swift
//  QuizPlease
//
//  Created by Владислав on 04.08.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import Foundation

//MARK:- Interactor Protocol
protocol ScheduleInteractorProtocol: class {
    ///must be weak
    var output: ScheduleInteractorOutput? { get set }
    
    func loadSchedule(filter: ScheduleFilter, completion: @escaping (Result<[GameInfo], NetworkServiceError>) -> Void)
    func loadDetailInfo(for game: GameInfo, completion: @escaping (GameInfo?) -> Void)
    
    func openInMaps(placeName: String, withLongitutde lon: Double, andLatitude lat: Double)
    func openInMaps(place: Place)
    
    func getSubscribeStatus(gameId: String)
    func getSubscribedGameIds(completion: @escaping ((Array<Int>) -> Void))
}

protocol ScheduleInteractorOutput: class {
    func interactor(_ interactor: ScheduleInteractorProtocol?, failedToOpenMapsWithError error: Error)
    func interactor(_ interactor: ScheduleInteractorProtocol?, didGetSubscribeStatus isSubscribed: Bool, forGameWithId id: String)
    func interactor(_ interactor: ScheduleInteractorProtocol?, failedToSubscribeForGameWith gameId: String, error: NetworkServiceError)
}

class ScheduleInteractor: ScheduleInteractorProtocol {
    weak var output: ScheduleInteractorOutput?
    
    func loadSchedule(filter: ScheduleFilter, completion: @escaping (Result<[GameInfo], NetworkServiceError>) -> Void) {
        NetworkService.shared.getSchedule(with: filter) { (serverResult) in
            switch serverResult {
            case let .failure(error):
                completion(.failure(error))
            case let .success(gamesList):
                let gamesInfo: [GameInfo] = gamesList.map { GameInfo(shortInfo: $0) }
                completion(.success(gamesInfo))
            }
        }
    }
    
    func loadDetailInfo(for game: GameInfo, completion: @escaping (GameInfo?) -> Void) {
        NetworkService.shared.getGameInfo(by: game.id) { (result) in
            switch result {
            case let .failure(error):
                print(error)
                completion(nil)
            case let .success(gameInfo):
                var fullInfo = gameInfo
                fullInfo.setShortInfo(game)
                completion(fullInfo)
            }
        }
    }
    
    func openInMaps(placeName: String, withLongitutde lon: Double, andLatitude lat: Double) {
        MapService.openAppleMaps(for: placeName, withLongitude: lon, andLatitude: lat)
    }
    
    func openInMaps(place: Place) {
        if !place.isZeroCoordinate {
            MapService.openAppleMaps(for: place.title ?? "", withCoordinate: place.coordinate)
        }
        MapService.getCoordinatesAndOpenMap(for: place.title ?? "", withAddress: place.fullAddress) { [weak self] error in
            guard let self = self else { return }
            if let error = error {
                self.output?.interactor(self, failedToOpenMapsWithError: error)
            }
        }
    }
    
    func getSubscribeStatus(gameId: String) {
        NetworkService.shared.subscribePushOnGame(with: gameId) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .failure(error):
                self.output?.interactor(self, failedToSubscribeForGameWith: gameId, error: error)
            case let .success(isSubscribed):
                self.output?.interactor(self, didGetSubscribeStatus: isSubscribed, forGameWithId: gameId)
            }
        }
    }
    
    func getSubscribedGameIds(completion: @escaping ((Array<Int>) -> Void)) {
        NetworkService.shared.getUserInfo { (result) in
            switch result {
            case let .failure(error):
                print(error)
                completion([])
            case let .success(userInfo):
                completion(userInfo.subscribedGames)
            }
        }
    }
}
