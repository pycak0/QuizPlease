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
    func load(gameId: Int, completion: @escaping (Result<GameInfo, Error>) -> Void)
}

/// Service that loads Game info
final class GameInfoLoaderImpl: GameInfoLoader {

    // MARK: - Private Properties

    private let cache: InMemoryCache<Int, GameInfo>
    private let networkService: NetworkServiceProtocol

    // MARK: - Lifecycle

    init(
        cache: InMemoryCache<Int, GameInfo> = InMemoryCache(),
        networkService: NetworkServiceProtocol
    ) {
        self.cache = cache
        self.networkService = networkService
    }

    // MARK: - GameInfoLoader

    func load(gameId: Int, completion: @escaping (Result<GameInfo, Error>) -> Void) {
        if let game = cache.get(key: gameId) {
            completion(.success(game))
            return
        }

        networkService.get(
            GameInfo.self,
            apiPath: "/ajax/scope-game",
            parameters: ["id": "\(gameId)"]
        ) { [weak self] result in
            guard let self else { return }
            switch result {
            case let .success(game):
                self.cache.set(game, for: gameId)
                completion(.success(game))

            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
}
