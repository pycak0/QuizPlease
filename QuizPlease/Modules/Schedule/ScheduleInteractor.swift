//
//  ScheduleInteractor.swift
//  QuizPlease
//
//  Created by Владислав on 04.08.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import Foundation

// MARK: - Interactor Protocol
protocol ScheduleInteractorProtocol: AnyObject {
    /// must be weak
    var output: ScheduleInteractorOutput? { get set }

    func loadSchedule(filter: ScheduleFilter, completion: @escaping (Result<[GameInfo], NetworkServiceError>) -> Void)
    func loadDetailInfo(for game: GameInfo, completion: @escaping (GameInfo?) -> Void)

    func getSubscribeStatus(gameId: Int)
    func getSubscribedGameIds(completion: @escaping ((Set<Int>) -> Void))

    func getExtraInfoText(completion: @escaping (AlertData?) -> Void)
}

protocol ScheduleInteractorOutput: AnyObject {

    func interactor(
        _ interactor: ScheduleInteractorProtocol?,
        failedToOpenMapsWithError error: Error
    )

    func interactor(
        _ interactor: ScheduleInteractorProtocol?,
        didGetSubscribeStatus response: ScheduleGameSubscriptionResponse,
        forGameWithId id: Int
    )

    func interactor(
        _ interactor: ScheduleInteractorProtocol?,
        failedToSubscribeForGameWith gameId: Int,
        error: NetworkServiceError
    )
}

final class ScheduleInteractor: ScheduleInteractorProtocol {

    weak var output: ScheduleInteractorOutput?

    private let gameInfoLoader: GameInfoLoader

    init(gameInfoLoader: GameInfoLoader) {
        self.gameInfoLoader = gameInfoLoader
    }

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
        gameInfoLoader.load(gameId: game.id) { result in
            switch result {
            case let .failure(error):
                print(error)
                completion(nil)
            case let .success(gameInfo):
                var fullInfo = gameInfo
                fullInfo.setShortInfo(game)
                /// cells don't have time to update the content when the game is loaded from cache
                /// временный костыль из-за того, что ячейка почему-то не обновляется второй раз 
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                    completion(fullInfo)
                }
            }
        }
    }

    func getSubscribeStatus(gameId: Int) {
        NetworkService.shared.subscribePushOnGame(with: gameId) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .failure(error):
                self.output?.interactor(self, failedToSubscribeForGameWith: gameId, error: error)
            case let .success(subscriptionResponse):
                self.output?.interactor(self, didGetSubscribeStatus: subscriptionResponse, forGameWithId: gameId)
            }
        }
    }

    func getSubscribedGameIds(completion: @escaping ((Set<Int>) -> Void)) {
        NetworkService.shared.getUserInfo { result in
            switch result {
            case let .failure(error):
                print(error)
                completion(Set())
            case let .success(userInfo):
                completion(userInfo.subscribedGames)
            }
        }
    }

    func getExtraInfoText(completion: @escaping (AlertData?) -> Void) {
        NetworkService.shared.getStandard(
            AlertData.self,
            apiPath: "/api/game/reserve-info",
            parameters: [:]
        ) { result in
            completion(try? result.get())
        }
    }
}
