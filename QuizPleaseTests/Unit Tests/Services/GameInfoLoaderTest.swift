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

    func testGameInfoDecodesMaxParticipants() throws {
        let json = """
        {
          "id": "game-id",
          "nameGame": "Game",
          "blockData": "date",
          "time": "19:00",
          "price": "1000",
          "text": "с человека",
          "place": "Place",
          "cityName": "City",
          "payment_icon": 0,
          "game_type": 0,
          "price_type": 0,
          "blockOf": 10,
          "max_participants": 12
        }
        """.data(using: .utf8)!

        let game = try JSONDecoder().decode(GameInfo.self, from: json)

        XCTAssertEqual(game.maxParticipants, 12)
    }

    func testGameInfoFormatsPriceWithCurrencySymbol() throws {
        let json = """
        {
          "id": "game-id",
          "nameGame": "Game",
          "blockData": "date",
          "time": "19:00",
          "price": "1000 ₽",
          "currency_symbol": "€",
          "text": "стоимость, с человека",
          "place": "Place",
          "cityName": "City",
          "payment_icon": 0,
          "game_type": 0,
          "price_type": 0,
          "blockOf": 10
        }
        """.data(using: .utf8)!

        let game = try JSONDecoder().decode(GameInfo.self, from: json)

        XCTAssertEqual(game.currencySymbol, "€")
        XCTAssertEqual(game.priceWithCurrency, "1000 €")
        XCTAssertEqual(game.priceDetails, "1000 € стоимость, с человека")
    }

    func testGameInfoFallsBackToRubleCurrencySymbol() throws {
        let game = try JSONDecoder().decode(GameInfo.self, from: gameInfoJson(maxParticipants: nil))

        XCTAssertEqual(game.currencySymbol, "₽")
        XCTAssertEqual(game.priceWithCurrency, "1000 ₽")
    }

    func testGameInfoUsesDefaultMaxParticipantsWhenValueIsMissing() throws {
        let json = """
        {
          "id": "game-id",
          "nameGame": "Game",
          "blockData": "date",
          "time": "19:00",
          "price": "1000",
          "text": "с человека",
          "place": "Place",
          "cityName": "City",
          "payment_icon": 0,
          "game_type": 0,
          "price_type": 0,
          "blockOf": 10
        }
        """.data(using: .utf8)!

        let game = try JSONDecoder().decode(GameInfo.self, from: json)

        XCTAssertEqual(game.maxParticipants, GameInfo.defaultMaxParticipants)
    }

    func testGameInfoKeepsCurrencySymbolWhenFullInfoDoesNotHaveIt() throws {
        var game = try JSONDecoder().decode(
            GameInfo.self,
            from: gameInfoJson(maxParticipants: nil)
        )
        let shortInfo = try JSONDecoder().decode(
            GameInfo.self,
            from: gameInfoJson(maxParticipants: nil, currencySymbol: "€")
        )

        game.setShortInfo(shortInfo)

        XCTAssertEqual(game.currencySymbol, "€")
        XCTAssertEqual(game.priceWithCurrency, "1000 €")
    }

    func testGameInfoKeepsMaxParticipantsWhenShortInfoDoesNotHaveIt() throws {
        var game = try JSONDecoder().decode(GameInfo.self, from: gameInfoJson(maxParticipants: 12))
        let shortInfo = try JSONDecoder().decode(GameInfo.self, from: gameInfoJson(maxParticipants: nil))

        game.setShortInfo(shortInfo)

        XCTAssertEqual(game.maxParticipants, 12)
    }

    private func gameInfoJson(maxParticipants: Int?, currencySymbol: String? = nil) -> Data {
        let maxParticipantsLine = maxParticipants
            .map { ",\n          \"max_participants\": \($0)" }
            ?? ""
        let currencySymbolLine = currencySymbol
            .map { ",\n          \"currency_symbol\": \"\($0)\"" }
            ?? ""
        return """
        {
          "id": "game-id",
          "nameGame": "Game",
          "blockData": "date",
          "time": "19:00",
          "price": "1000",
          "text": "с человека",
          "place": "Place",
          "cityName": "City",
          "payment_icon": 0,
          "game_type": 0,
          "price_type": 0,
          "blockOf": 10\(maxParticipantsLine)\(currencySymbolLine)
        }
        """.data(using: .utf8)!
    }
}

final class RatingExternalResponseDecodingTest: XCTestCase {

    func testRatingExternalLeaguesResponseDecodesBackendContract() throws {
        let json = """
        {
          "result": [
            {
              "id": 1,
              "title": "Classic",
              "code": "classic",
              "is_created": true,
              "is_loaded": true
            }
          ]
        }
        """.data(using: .utf8)!

        let response = try JSONDecoder().decode(RatingLeagueResponseData.self, from: json)
        let league = try XCTUnwrap(response.result.first)

        XCTAssertEqual(league.id, 1)
        XCTAssertEqual(league.title, "Classic")
        XCTAssertEqual(league.code, "classic")
        XCTAssertEqual(league.isCreated, true)
        XCTAssertEqual(league.isLoaded, true)
    }

    func testRatingExternalTeamsResponseDecodesAndMapsBackendContract() throws {
        let json = """
        {
          "result": [
            {
              "id": 854334,
              "index": 17,
              "title": "Team",
              "points": 548.5,
              "games": 9,
              "rank": {
                "title": "Legend",
                "image_path": "https://cdn.example.com/rank.png"
              }
            }
          ],
          "totalCount": 1
        }
        """.data(using: .utf8)!

        let response = try JSONDecoder().decode(RatingTeamResponseData.self, from: json)
        let itemData = try XCTUnwrap(response.result.first)
        let item = RatingTeamDataToItemMapperImpl().map(itemData, place: 1)

        XCTAssertEqual(item.place, 17)
        XCTAssertEqual(item.name, "Team")
        XCTAssertEqual(item.games, 9)
        XCTAssertEqual(item.pointsTotal, 548.5)
        XCTAssertEqual(item.rank, "Legend")
        XCTAssertEqual(item.imagePath, "https://cdn.example.com/rank.png")
    }
}
