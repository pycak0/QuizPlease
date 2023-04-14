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

    private var cacheMock: InMemoryCacheMock<Int, GameInfo>!
    private var networkServiceMock: NetworkServiceMock<GameInfo>!
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
        networkServiceMock.resultMock = .success(game)

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
}
