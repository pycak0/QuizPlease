//
//  GameInfoLoaderTest.swift
//  QuizPleaseTests
//
//  Created by Владислав on 14.04.2023.
//  Copyright © 2023 Владислав. All rights reserved.
//

@testable import QuizPlease
import XCTest

final class GameInfoLoaderTest: XCTestCase {

    private typealias GameInfoResponse = ServerResponse<ServerResponse<GameInfo>>

    private var cacheMock: InMemoryCacheMock<String, GameInfo>!
    private var networkServiceMock: NetworkServiceMock<GameInfoResponse>!
    private var gameInfoLoader: GameInfoLoaderImpl!

    override func setUp() {
        super.setUp()
        cacheMock = InMemoryCacheMock()
        networkServiceMock = NetworkServiceMock()
        gameInfoLoader = GameInfoLoaderImpl(cache: cacheMock, networkService: networkServiceMock)
    }

    override func tearDown() {
        gameInfoLoader = nil
        cacheMock = nil
        networkServiceMock = nil
        super.tearDown()
    }

    func testWithEmptyCache() {
        // Arrange
        let game = GameInfo.test
        let gameIdMock = game.id!
        cacheMock.getMock = nil
        networkServiceMock.resultMock = .success(.init(data: .init(data: game)))

        // Act
        var acutalResult: GameInfo?
        gameInfoLoader.load(gameId: gameIdMock) { result in
            acutalResult = try? result.get()
        }

        // Assert
        XCTAssertEqual(acutalResult?.id, game.id, "Game id is not equal")
        XCTAssert(networkServiceMock.getCalled)
        XCTAssert(cacheMock.getCalled)
        XCTAssert(cacheMock.setCalled)
    }

    func testWithNonEmptyCache() {
        // Arrange
        let game = GameInfo.test
        let gameIdMock = game.id!
        cacheMock.getMock = game
        networkServiceMock.resultMock = .failure(.invalidToken)

        // Act
        var acutalResult: GameInfo?
        gameInfoLoader.load(gameId: gameIdMock) { result in
            acutalResult = try? result.get()
        }

        // Assert
        XCTAssertEqual(acutalResult?.id, game.id, "Game id is not equal")
        XCTAssertFalse(networkServiceMock.getCalled)
        XCTAssert(cacheMock.getCalled)
        XCTAssertFalse(cacheMock.setCalled)
    }

    func testPassedGameDecodesHistoryDateAndTime() throws {
        let json = """
        {
          "id": "game-id",
          "name": "1234",
          "title": "Классика",
          "place": "Бар \"Маяк\"",
          "datetime": "21.06.26 19:00"
        }
        """.data(using: .utf8)!

        let game = try JSONDecoder().decode(PassedGame.self, from: json)

        XCTAssertEqual(game.gameNumber, "#1234")
        XCTAssertEqual(game.title, "Классика")
        XCTAssertEqual(game.place, "Бар \"Маяк\"")
        XCTAssertEqual(game.dateAndTime, "21.06.26 19:00")
    }
}
