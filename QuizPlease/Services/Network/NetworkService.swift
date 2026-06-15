//
//  NetworkService.swift
//  QuizPlease
//
//  Created by Владислав on 27.08.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import Foundation

// swiftlint:disable file_length
// swiftlint:disable type_body_length
class NetworkService {
    private init() {}

    typealias Completion<Object: Decodable> = (Result<Object, NetworkServiceError>) -> Void

    enum AuthorizationKind: Equatable {
        case none, bearer, bearerCustom(_ token: String)
    }

    static let shared = NetworkService()

    private let networkService: NetworkServiceProtocol = ServiceAssembly.shared.networkService

    var baseUrlComponents: URLComponents {
        var urlComps = URLComponents(string: NetworkConfiguration.standard.host)!
        urlComps.queryItems = nil
        return urlComps
    }

    private func createBearerAuthHeader(
        with token: String? = DefaultsManager.shared.getUserAuthInfo()?.accessToken
    ) -> (key: String, value: String)? {
        guard let userToken = token else {
            return nil
        }
        return ("Authorization", "Bearer \(userToken)")
    }

    static func mapResponse<Object: Decodable>(_ data: Data, to: Object.Type) -> Result<Object, NetworkServiceError> {
        do {
            let object = try JSONDecoder().decode(Object.self, from: data)
            return .success(object)
        } catch {
            return .failure(.decoding(error))
        }
    }

    //
    // MARK: - GET REQUESTS =======
    //
    //

    // MARK: - Settings
    func getSettings(cityId: Int, completion: @escaping (Result<ClientSettings, NetworkServiceError>) -> Void) {
        let parameters: [String: String?] = [
            "city_id": "\(cityId)"
        ]
        getStandard(
            ClientSettings.self,
            apiPath: ApiConstants.Path.settings,
            parameters: parameters,
            completion: completion
        )
    }

    // MARK: - Get Cities
    func getCities(completion: @escaping (Result<[City], NetworkServiceError>) -> Void) {
        getStandard(CityResponse.self, apiPath: ApiConstants.Path.city, parameters: nil) { (getResult) in
            switch getResult {
            case let .failure(error):
                completion(.failure(error))
            case let .success(cityResponse):
                completion(.success(cityResponse.data))
            }
        }
    }

    // MARK: - Get Rating
    // swiftlint:disable:next function_parameter_count
    func getRating(
        cityId: Int,
        teamName: String,
        league: Int,
        ratingScope: Int,
        page: Int,
        completion: @escaping (Result<[RatingTeamItem], NetworkServiceError>) -> Void
    ) -> Cancellable? {
        var parameters: [String: String?] = [
            "city_id": "\(cityId)",
            "league": "\(league)",
            "general": "\(ratingScope)",
            "page": "\(page)"
        ]
        if teamName.count > 0 {
            parameters["teamName"] = teamName
        }
        return networkService.get(
            ServerResponse<[RatingTeamItem]>.self,
            apiPath: ApiConstants.Path.rating,
            parameters: parameters,
            headers: nil,
            authorizationKind: .none,
            networkConfiguration: .rating
        ) { serverResponse in
            switch serverResponse {
            case let .failure(error):
                completion(.failure(error))
            case let .success(response):
                completion(.success(response.data))
            }
        }
    }

    // MARK: - Get Shop Items
    func getShopItems(cityId: Int? = nil, completion: @escaping (Result<[ShopItem], NetworkServiceError>) -> Void) {
        let id = cityId ?? AppSettings.defaultCity.id
        let parameters: [String: String?] = [
            "city_id": "\(id)"
        ]
        getStandard([ShopItem].self, apiPath: ApiConstants.Path.product, parameters: parameters, completion: completion)
    }

    // MARK: - Home Games List
    /// - parameter cityId: Optional city parameter. If `nil`, user's `defaultCity` is used.
    func getHomeGames(cityId: Int? = nil, completion: @escaping (Result<[HomeGame], NetworkServiceError>) -> Void) {
        let id = cityId ?? AppSettings.defaultCity.id
        let parameters: [String: String?] = [
            "city_id": "\(id)"
        ]
        getStandard([HomeGame].self, apiPath: ApiConstants.Path.homeGame, parameters: parameters, completion: completion)
    }

    // MARK: - Home Game by ID
    func getHomeGame(by id: Int, completion: @escaping (Result<HomeGame, NetworkServiceError>) -> Void) {
        getStandard(HomeGame.self, apiPath: ApiConstants.Path.homeGame(id: id), parameters: nil, completion: completion)
    }

    // MARK: - Get Game Info
    func getGameInfo(by id: String, completion: @escaping (Result<GameInfo, NetworkServiceError>) -> Void) {
        let parameters: [String: String?] = [
            "id": "\(id)"
        ]
        networkService.get(
            GameInfo.self,
            apiPath: ApiConstants.Path.ajaxScopeGame,
            parameters: parameters,
            completion: completion
        )
    }

    // MARK: - Get Filter Options
    /// Used for filtering schedule
    /// - parameter cityId: Optionally request scoping the results for given city id
    func getFilterOptions(
        _ type: ScheduleFilterType,
        scopeFor cityId: Int? = nil,
        completion: @escaping (Result<ServerResponse<[ScheduleFilterOption]>, NetworkServiceError>) -> Void
    ) {
        var parameters: [String: String?] = [
            "isMobile": "1"
        ]
        if let id = cityId {
            parameters["city_id"] = "\(id)"
        }
        let apiPath = ApiConstants.Path.gameFilter(type.rawValue)
        getStandard(ServerResponse<[ScheduleFilterOption]>.self, apiPath: apiPath, parameters: parameters, completion: completion)
    }

    // MARK: - Get Standard Server Request
    /// A get request for standard server response containing requested object in `data` field.
    /// You should mostly use this method rather than simple `get(:urlComponents:completion:)`.
    @discardableResult
    func getStandard<T: Decodable>(
        _ type: T.Type,
        apiPath: String,
        parameters: [String: String?]? = nil,
        headers: [String: String]? = nil,
        authorizationKind: AuthorizationKind = .none,
        completion: @escaping ((Result<T, NetworkServiceError>) -> Void)
    ) -> Cancellable? {
        return networkService.get(
            ServerResponse<T>.self,
            apiPath: apiPath,
            parameters: parameters,
            headers: headers,
            authorizationKind: authorizationKind
        ) { getResult in
            switch getResult {
            case let .failure(error):
                completion(.failure(error))
            case let .success(response):
                completion(.success(response.data))
            }
        }
    }

    /// A get request for standard server response containing requested object in `data` field.
    /// You should mostly use this method rather than simple `get(:urlComponents:completion:)`.
    @discardableResult
    func getStandard<T: Decodable>(
        _ type: T.Type,
        with urlComps: URLComponents,
        headers: [String: String]? = nil,
        authorizationKind: AuthorizationKind = .none,
        completion: @escaping ((Result<T, NetworkServiceError>) -> Void)
    ) -> Cancellable? {
        networkService.get(
            ServerResponse<T>.self,
            apiPath: urlComps.path,
            parameters: urlComps.queryDictionary,
            headers: headers,
            authorizationKind: authorizationKind
        ) { getResult in
            switch getResult {
            case let .failure(error):
                completion(.failure(error))
            case let .success(response):
                completion(.success(response.data))
            }
        }
    }

    //
    // MARK: - POST REQUESTS =======
    //
    //

    // MARK: - Push Subscribe

    func subscribePushOnGame(
        with id: String,
        completion: @escaping (Result<ScheduleGameSubscriptionResponse, NetworkServiceError>) -> Void
    ) {
        guard let auth = createBearerAuthHeader() else {
            completion(.failure(.invalidToken))
            return
        }
        let headers = [auth.key: auth.value]
        let params = ["game_id": "\(id)"]
        afPostStandard(
            bodyParameters: params,
            and: headers,
            to: ApiConstants.Path.gameSubscribeNotification,
            responseType: ScheduleGameSubscriptionResponse.self,
            completion: completion
        )
    }

    // MARK: - Purchase Product
    func purchaseProduct(
        with id: String,
        deliveryMethod: DeliveryMethod,
        email: String,
        completion: @escaping (Result<ShopPurchaseResponse, NetworkServiceError>) -> Void
    ) {
        guard let auth = createBearerAuthHeader() else {
            completion(.failure(.invalidToken))
            return
        }
        let headers = [auth.key: auth.value]
        let params: [String: String] = [
            "product_id": id,
            "delivery_method": "\(deliveryMethod.id)",
            "email": email,
            "city_id": "\(AppSettings.defaultCity.id)"
        ]
        afPostStandard(
            bodyParameters: params,
            and: headers,
            to: ApiConstants.Path.orderBuy,
            responseType: ShopPurchaseResponse.self,
            completion: completion
        )
    }

    // MARK: - Check In On Game

    func checkInOnGame(
        with qrCode: String,
        chosenTeamId: Int,
        completion: @escaping (Result<AddGameResponse, NetworkServiceError>) -> Void
    ) {
        guard let auth = createBearerAuthHeader() else {
            completion(.failure(.invalidToken))
            return
        }
        let headers = [auth.key: auth.value]
        let params = [
            "token": "\(qrCode)",
            "recordId": "\(chosenTeamId)"
        ]
        afPostStandard(
            bodyParameters: params,
            and: headers,
            to: ApiConstants.Path.gameCheckQR,
            responseType: AddGameResponse.self,
            completion: completion
        )
    }

    // MARK: - Get Teams List From QR
    func getTeamsFromQR(
        _ qrCode: String,
        completion: @escaping (Result<[TeamInfo], NetworkServiceError>) -> Void
    ) {
        guard let auth = createBearerAuthHeader() else {
            completion(.failure(.invalidToken))
            return
        }
        let headers = [auth.key: auth.value]
        let params = ["token": "\(qrCode)"]
        afPostStandard(bodyParameters: params, and: headers, to: ApiConstants.Path.gameCheckQR, responseType: CheckInTeamsInfo.self) { (postResult) in
            switch postResult {
            case let .failure(error):
                completion(.failure(error))

            case let .success(response):
                if response.records.count > 0 {
                    completion(.success(response.records))
                } else {
                    print(response)
                    completion(.failure(.jsonError))
                }
            }
        }
    }

    // MARK: - Send Firebase ID
    func sendFirebaseId(_ fcmToken: String) {
        guard let auth = createBearerAuthHeader() else { return }
        let headers = [auth.key: auth.value]
        let params = ["device_id": fcmToken]
        afPostStandard(
            bodyParameters: params,
            and: headers,
            to: ApiConstants.Path.deviceCreate,
            responseType: [String: String].self
        ) { (postResult) in
            print("Firebase ID sending result:")
            print(postResult)
        }
    }

    func setDefaultCity(_ city: City) {
        guard let auth = createBearerAuthHeader() else { return }
        let headers = [auth.key: auth.value]
        let params = ["city_id": "\(city.id)"]
        afPostStandard(bodyParameters: params, and: headers, to: ApiConstants.Path.setUserCity, responseType: AnyDecodable.self) { result in
            print("Default city setting result:")
            print(result)
        }
    }

    // MARK: - AF Post Auth
    /// Post request with response type of `SavedAuthInfo`
    func afPostAuth(
        with parameters: [String: String?],
        to apiPath: String,
        completion: @escaping ((Result<SavedAuthInfo, NetworkServiceError>) -> Void)
    ) {
        afPostStandard(bodyParameters: parameters, to: apiPath, responseType: AuthInfoResponse.self) { (postResult) in
            switch postResult {
            case let .failure(error):
                completion(.failure(error))
            case let .success(response):
                if let message = response.message {
                    let error = NSError(domain: message, code: response.status ?? -999, userInfo: nil)
                    completion(.failure(.other(error)))
                    return
                }
                let authInfo = SavedAuthInfo(authInfoResponse: response)
                completion(.success(authInfo))
            }
        }
    }

    // MARK: - Post with Bool completion

    /// Wraps server response to the success or failure.
    /// Use this method if you don't mind about data that is passed via response
    /// and you only want to know if the request was successul or not.
    func afPostBool(
        with parameters: [String: String?],
        and headers: [String: String]? = nil,
        to apiPath: String,
        completion: @escaping ((_ isSuccess: Bool) -> Void)
    ) {
        afPostStandard(
            bodyParameters: parameters,
            and: headers,
            to: apiPath,
            responseType: [String: AnyDecodable?]?.self
        ) { (postResult) in
            let isSuccess = (try? postResult.get()) != nil
            completion(isSuccess)
        }
    }

    // MARK: - AF Post Standard
    /// Makes POST request with afPost method,
    /// then wraps server reponse into the `ServerResponse<Response>` struct,
    /// where `Response` type is passed via `responseType` parameter.
    func afPostStandard<Response: Decodable>(
        bodyParameters: [String: String?],
        and headers: [String: String]? = nil,
        to apiPath: String,
        queryParameters: [String: String?]? = nil,
        responseType: Response.Type,
        authorizationKind: AuthorizationKind = .none,
        completion: @escaping ((Result<Response, NetworkServiceError>) -> Void)
    ) {
        networkService.afPost(
            with: bodyParameters,
            queryParameters: queryParameters,
            and: headers,
            to: apiPath,
            responseType: ServerResponse<Response>.self,
            authorizationKind: authorizationKind
        ) { postResult in
            switch postResult {
            case let .failure(error):
                completion(.failure(error))
            case let .success(result):
                completion(.success(result.data))
            }
        }
    }
}
// swiftlint:enable type_body_length
