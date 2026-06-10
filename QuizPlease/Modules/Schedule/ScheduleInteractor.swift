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

    func getSubscribeStatus(gameId: String)
    func getSubscribedGameIds(completion: @escaping ((Set<String>) -> Void))

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
        forGameWithId id: String
    )

    func interactor(
        _ interactor: ScheduleInteractorProtocol?,
        failedToSubscribeForGameWith gameId: String,
        error: NetworkServiceError
    )
}

final class ScheduleInteractor: ScheduleInteractorProtocol {

    weak var output: ScheduleInteractorOutput?

    private enum Constants {
        static let gamesPerPage = 30
    }

    private let networkService: NetworkServiceProtocol
    private let gameInfoLoader: GameInfoLoader
    private let userService: UserService

    init(
        networkService: NetworkServiceProtocol,
        gameInfoLoader: GameInfoLoader,
        userService: UserService
    ) {
        self.networkService = networkService
        self.gameInfoLoader = gameInfoLoader
        self.userService = userService
    }

    func loadSchedule(filter: ScheduleFilter, completion: @escaping (Result<[GameInfo], NetworkServiceError>) -> Void) {
        loadSchedulePage(filter: filter, page: 1, loadedGames: [], completion: completion)
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

    func getSubscribeStatus(gameId: String) {
        networkService.afPost(
            with: ["game_id": "\(gameId)"],
            queryParameters: nil,
            and: nil,
            to: ApiConstants.Path.gameSubscribeNotification,
            responseType: ServerResponse<ScheduleGameSubscriptionResponse>.self,
            authorizationKind: .bearer
        ) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .failure(error):
                self.output?.interactor(self, failedToSubscribeForGameWith: gameId, error: error)
            case let .success(response):
                self.output?.interactor(self, didGetSubscribeStatus: response.data, forGameWithId: gameId)
            }
        }
    }

    func getSubscribedGameIds(completion: @escaping ((Set<String>) -> Void)) {
        userService.getUserInfo { result in
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
        networkService.get(
            ServerResponse<AlertData>.self,
            apiPath: "/api/game/reserve-info",
            parameters: nil,
            headers: nil,
            authorizationKind: .none,
            networkConfiguration: .standard
        ) { result in
            completion(try? result.get().data)
        }
    }
}

private extension ScheduleInteractor {

    func loadSchedulePage(
        filter: ScheduleFilter,
        page: Int,
        loadedGames: [GameShortInfo],
        completion: @escaping (Result<[GameInfo], NetworkServiceError>) -> Void
    ) {
        networkService.get(
            ServerResponse<ScheduledGamesResponse>.self,
            apiPath: ApiConstants.Path.game,
            parameters: scheduleParameters(filter: filter, page: page),
            headers: nil,
            authorizationKind: .none,
            networkConfiguration: .standard
        ) { [weak self] result in
            guard let self else { return }

            switch result {
            case let .failure(error):
                completion(.failure(error))

            case let .success(response):
                let pageGames = response.data.data
                let allGames = loadedGames + pageGames

                guard pageGames.count == Constants.gamesPerPage else {
                    completion(.success(allGames.map { GameInfo(shortInfo: $0) }))
                    return
                }

                self.loadSchedulePage(
                    filter: filter,
                    page: page + 1,
                    loadedGames: allGames,
                    completion: completion
                )
            }
        }
    }

    func scheduleParameters(filter: ScheduleFilter, page: Int) -> [String: String?] {
        var parameters: [String: String?] = [
            "city_id": "\(filter.city.id)",
            "isMobile": "1",
            "order": "date",
            "per_page": "\(Constants.gamesPerPage)",
            "page": "\(page)"
        ]

        if let id = filter.date?.id {
            parameters["month"] = "\(id)"
        }
        if let id = filter.format?.id {
            parameters["formats[]"] = "\(id)"
        }
        if let id = filter.place?.id {
            parameters["places[]"] = "\(id)"
        }
        if let id = filter.status?.id {
            parameters["statuses[]"] = "\(id)"
        }
        if let id = filter.type?.id {
            parameters["game_types[]"] = "\(id)"
        }

        return parameters
    }
}
