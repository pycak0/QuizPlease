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

    func testSignedUpGameDecodesBackendContract() throws {
        let json = """
        {
          "data": {
            "data": [
              {
                "id": "019e3f02-9f57-706b-ad37-9f45e9027e63",
                "place": {
                  "title": "Papa's Bar & Grill"
                },
                "date": "2026-06-05T16:00:00.000000Z",
                "title": "Квиз, плиз! [изи]",
                "game_number": "22",
                "package_number": "изи22",
                "status": 4
              }
            ]
          }
        }
        """.data(using: .utf8)!

        let response = try JSONDecoder().decode(
            ServerResponse<ServerResponse<[SignedUpGame]>>.self,
            from: json
        )
        let game = try XCTUnwrap(response.data.data.first)

        XCTAssertEqual(game.gameNumber, "#22")
        XCTAssertEqual(game.title, "Квиз, плиз! [изи]")
        XCTAssertEqual(game.placeTitle, "Papa's Bar & Grill")
        XCTAssertEqual(game.dateAndTime, "5 июня, 19:00")
        XCTAssertTrue(game.isFinished)
        XCTAssertNil(game.teamName)
    }
}
