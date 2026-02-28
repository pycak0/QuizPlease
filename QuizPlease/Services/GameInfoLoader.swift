//
//  GameInfoLoader.swift
//  QuizPlease
//
//  Created by Владислав on 14.04.2023.
//  Copyright © 2023 Владислав. All rights reserved.
//

import Foundation

/// Service that loads Game info
protocol GameInfoLoader {

    /// Load the game by id
    func load(gameId: String, completion: @escaping (Result<GameInfo, Error>) -> Void)

    func getCachedGame(gameId: String) -> GameInfo?
}

/// Service that loads Game info
final class GameInfoLoaderImpl: GameInfoLoader {

    // MARK: - Private Properties

    private let cache: InMemoryCache<String, GameInfo>
    private let networkService: NetworkServiceProtocol

    // MARK: - Lifecycle

    init(
        cache: InMemoryCache<String, GameInfo> = InMemoryCache(),
        networkService: NetworkServiceProtocol
    ) {
        self.cache = cache
        self.networkService = networkService
    }

    // MARK: - GameInfoLoader

    func load(gameId: String, completion: @escaping (Result<GameInfo, Error>) -> Void) {
        if let game = cache.get(key: gameId) {
            completion(.success(game))
            return
        }

        networkService.get(
            ServerResponse<ServerResponse<GameInfo>>.self,
            apiPath: "/ajax/scope-game",
            parameters: ["id": "\(gameId)"]
        ) { [weak self] result in
            guard let self else { return }
            switch result {
            case let .success(response):
                let game = response.data.data
                self.cache.set(game, for: gameId)
                completion(.success(game))

            case let .failure(error):
                completion(.failure(error))
            }
        }
    }

    func getCachedGame(gameId: String) -> GameInfo? {
        cache.get(key: gameId)
    }
}
