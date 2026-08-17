//
//  UITestServiceStubs.swift
//  QuizPlease
//
//  Created by Codex on 07.07.2026.
//  Copyright © 2026 Владислав. All rights reserved.
//

#if DEBUG

import CoreLocation

final class UITestGameInfoLoader: GameInfoLoader {

    private let game: GameInfo

    init(game: GameInfo) {
        self.game = game
    }

    func load(gameId: String, completion: @escaping (Result<GameInfo, Error>) -> Void) {
        completion(.success(game))
    }

    func getCachedGame(gameId: String) -> GameInfo? {
        game
    }
}

final class UITestPlaceGeocoder: PlaceGeocoderProtocol {

    func getCoordinate(_ place: Place, completion: @escaping (CLLocationCoordinate2D) -> Void) {
        completion(CLLocationCoordinate2D(latitude: 0, longitude: 0))
    }
}

final class UITestAnalyticsService: AnalyticsService {

    func sendEvent(_ event: AnalyticsEvent) { }
}

final class UITestRatingNetworkService: NetworkServiceProtocol {

    @discardableResult
    func get<T: Decodable>(
        _ type: T.Type,
        apiPath: String,
        parameters: [String: String?]?,
        headers: [String: String]?,
        authorizationKind: NetworkService.AuthorizationKind,
        networkConfiguration: NetworkConfiguration,
        completion: @escaping ((Result<T, NetworkServiceError>) -> Void)
    ) -> Cancellable? {
        let response: Any

        switch apiPath {
        case ApiConstants.Path.ratingExternal:
            response = RatingLeagueResponseData(result: [
                RatingLeagueData(
                    id: 1,
                    title: "Классический",
                    code: "classic",
                    isCreated: true,
                    isLoaded: true
                )
            ])
        case ApiConstants.Path.ratingTeamsExternal:
            response = ratingTeamResponse(isSeason: (parameters?["bySeason"] ?? nil) == "true")
        default:
            completion(.failure(.invalidUrl))
            return nil
        }

        guard let typedResponse = response as? T else {
            completion(.failure(.jsonError))
            return nil
        }

        completion(.success(typedResponse))
        return nil
    }

    func afPost<Response: Decodable>(
        with bodyParameters: [String: String?],
        queryParameters: [String: String?]?,
        and headers: [String: String]?,
        to apiPath: String,
        responseType: Response.Type,
        authorizationKind: NetworkService.AuthorizationKind,
        completion: @escaping (Result<Response, NetworkServiceError>) -> Void
    ) {
        completion(.failure(.invalidUrl))
    }

    func afPost<Response: Decodable>(
        with multipartFormDataObjects: MultipartFormDataObjects,
        queryParameters: [String: String?]?,
        and headers: [String: String]?,
        to apiPath: String,
        responseType: Response.Type,
        authorizationKind: NetworkService.AuthorizationKind,
        completion: @escaping (Result<Response, NetworkServiceError>) -> Void
    ) {
        completion(.failure(.invalidUrl))
    }

    @discardableResult
    func post<Object: Encodable, Response: Decodable>(
        _ object: Object,
        apiPath: String,
        parameters: [String: String?]?,
        headers: [String: String]?,
        authorizationKind: NetworkService.AuthorizationKind,
        reponseType: Response.Type,
        completion: @escaping ((Result<Response, NetworkServiceError>) -> Void)
    ) -> Cancellable? {
        completion(.failure(.invalidUrl))
        return nil
    }

    private func ratingTeamResponse(isSeason: Bool) -> RatingTeamResponseData {
        if isSeason {
            return RatingTeamResponseData(result: [
                RatingTeamItemData(
                    index: 7,
                    title: "Season Team",
                    points: 1472,
                    games: 26,
                    rank: nil
                )
            ])
        }

        return RatingTeamResponseData(result: [
            RatingTeamItemData(
                index: 1,
                title: "All Time Team",
                points: 5000,
                games: 100,
                rank: nil
            )
        ])
    }
}

final class UITestScheduleCurrencyNetworkService: NetworkServiceProtocol {

    @discardableResult
    func get<T: Decodable>(
        _ type: T.Type,
        apiPath: String,
        parameters: [String: String?]?,
        headers: [String: String]?,
        authorizationKind: NetworkService.AuthorizationKind,
        networkConfiguration: NetworkConfiguration,
        completion: @escaping ((Result<T, NetworkServiceError>) -> Void)
    ) -> Cancellable? {
        guard apiPath == ApiConstants.Path.game else {
            completion(.failure(.invalidUrl))
            return nil
        }

        let json = """
        {
          "data": {
            "data": [
              {
                "id": "\(UITestGameFixtures.currencyGameId)",
                "datetime": "10.06.26 19:30",
                "currency_symbol": "€"
              }
            ]
          }
        }
        """

        guard
            let data = json.data(using: .utf8),
            let response = try? JSONDecoder().decode(T.self, from: data)
        else {
            completion(.failure(.jsonError))
            return nil
        }

        completion(.success(response))
        return nil
    }

    func afPost<Response: Decodable>(
        with bodyParameters: [String: String?],
        queryParameters: [String: String?]?,
        and headers: [String: String]?,
        to apiPath: String,
        responseType: Response.Type,
        authorizationKind: NetworkService.AuthorizationKind,
        completion: @escaping (Result<Response, NetworkServiceError>) -> Void
    ) {
        completion(.failure(.invalidUrl))
    }

    func afPost<Response: Decodable>(
        with multipartFormDataObjects: MultipartFormDataObjects,
        queryParameters: [String: String?]?,
        and headers: [String: String]?,
        to apiPath: String,
        responseType: Response.Type,
        authorizationKind: NetworkService.AuthorizationKind,
        completion: @escaping (Result<Response, NetworkServiceError>) -> Void
    ) {
        completion(.failure(.invalidUrl))
    }

    @discardableResult
    func post<Object: Encodable, Response: Decodable>(
        _ object: Object,
        apiPath: String,
        parameters: [String: String?]?,
        headers: [String: String]?,
        authorizationKind: NetworkService.AuthorizationKind,
        reponseType: Response.Type,
        completion: @escaping ((Result<Response, NetworkServiceError>) -> Void)
    ) -> Cancellable? {
        completion(.failure(.invalidUrl))
        return nil
    }
}

final class UITestUserService: UserService {

    var isloggedIn: Bool { false }

    func getUserInfo(completion: @escaping (Result<UserInfo, NetworkServiceError>) -> Void) {
        completion(.failure(.invalidToken))
    }

    func getSignedUpGames(completion: @escaping (Result<[SignedUpGame], NetworkServiceError>) -> Void) {
        completion(.failure(.invalidToken))
    }

    func loadUserInfo(completion: @escaping (Result<UserInfo, NetworkServiceError>) -> Void) {
        completion(.failure(.invalidToken))
    }

    func deleteAccount(completion: @escaping (Result<Void, NetworkServiceError>) -> Void) {
        completion(.failure(.invalidToken))
    }

    func updateToken(completion: (() -> Void)?) {
        completion?()
    }

    func logout() { }
}

#endif
