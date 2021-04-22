//
//  NetworkService.swift
//  QuizPlease
//
//  Created by Владислав on 27.08.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import Foundation
import Alamofire

class NetworkService {
    private init() {}
    
    enum AuthorizationKind: Equatable {
        case none, bearer, bearerCustom(_ token: String)
        
        var header: (key: String, value: String)? {
            switch self {
            case .none:
                return nil
            case .bearer:
                return NetworkService.shared.createBearerAuthHeader()
            case let .bearerCustom(token):
                return NetworkService.shared.createBearerAuthHeader(with: token)
            }
        }
    }
    
    static let shared = NetworkService()
        
    var baseUrlComponents: URLComponents {
        var urlComps = URLComponents(string: Configuration.dev.host)!
        urlComps.queryItems = nil
        return urlComps
    }
    
    private func createBearerAuthHeader(with token: String? = AppSettings.userToken) -> (key: String, value: String)? {
        guard let userToken = token else {
            return nil
        }
        return ("Authorization", "Bearer \(userToken)")
    }
        
    ///
    //MARK:- GET REQUESTS =======
    ///
    ///
    
    //MARK:- User Info
    func getUserInfo(completion: @escaping ((Result<UserInfo, SessionError>) -> Void)) {
        guard let auth = createBearerAuthHeader() else {
            completion(.failure(.invalidToken))
            return
        }
        let headers = [auth.key : auth.value]
        var userUrlComps = baseUrlComponents
        userUrlComps.path = "/api/users/current"
        getStandard(UserInfo.self, with: userUrlComps, headers: headers, completion: completion)
    }
    
    //MARK:- Settings
    func getSettings(cityId: Int, completion: @escaping (Result<ClientSettings, SessionError>) -> Void) {
        var settingsUrlComps = baseUrlComponents
        settingsUrlComps.path = "/api/settings"
        settingsUrlComps.queryItems = [
            URLQueryItem(name: "city_id", value: "\(cityId)")
        ]
        getStandard(ClientSettings.self, with: settingsUrlComps, completion: completion)
    }
        
    //MARK:- Get Cities
    func getCities(completion: @escaping (Result<[City], SessionError>) -> Void) {
        var cityUrlComponents = baseUrlComponents
        cityUrlComponents.path = "/api/city"
        
        getStandard(CityResponse.self, with: cityUrlComponents) { (getResult) in
            switch getResult {
            case let .failure(error):
                completion(.failure(error))
            case let .success(cityResponse):
                completion(.success(cityResponse.data))
            }
        }
    }
    
    //MARK:- Get Warmup Questions
    func getWarmupQuestions(completion: @escaping (Result<[WarmupQuestion], SessionError>) -> Void) {
        guard let auth = createBearerAuthHeader() else {
            completion(.failure(.invalidToken))
            return
        }
        let headers = [auth.key : auth.value]
        var warmupUrlComps = baseUrlComponents
        warmupUrlComps.path = "/api/warmup-question"
        getStandard([WarmupQuestion].self, with: warmupUrlComps, headers: headers, completion: completion)
    }
    
    //MARK:- Get Rating
    func getRating(cityId: Int, teamName: String, league: Int, ratingScope: Int, page: Int, completion: @escaping (Result<[RatingItem], SessionError>) -> Void) {
        var ratingUrlComponents = baseUrlComponents
        ratingUrlComponents.path = "/api/rating"
        ratingUrlComponents.queryItems = [
            URLQueryItem(name: "city_id", value: "\(cityId)"),
            URLQueryItem(name: "league", value: "\(league)"),
            URLQueryItem(name: "general", value: "\(ratingScope)"),
            URLQueryItem(name: "page", value: "\(page)")
        ]
        if teamName.count > 0 {
            ratingUrlComponents.queryItems?.append(URLQueryItem(name: "teamName", value: teamName))
        }
        getStandard([RatingItem].self, with: ratingUrlComponents, completion: completion)
    }
    
    //MARK:- Get Shop Items
    func getShopItems(cityId: Int? = nil, completion: @escaping (Result<[ShopItem], SessionError>) -> Void) {
        var shopUrlComponents = baseUrlComponents
        shopUrlComponents.path = "/api/product"
        
        let id = cityId ?? AppSettings.defaultCity.id
        shopUrlComponents.queryItems = [
            URLQueryItem(name: "city_id", value: "\(id)")
        ]
        getStandard([ShopItem].self, with: shopUrlComponents, completion: completion)
    }
    
    //MARK:- Home Games List
    ///- parameter cityId: Optional city parameter. If `nil`, user's `defaultCity` is used.
    func getHomeGames(cityId: Int? = nil, completion: @escaping (Result<[HomeGame], SessionError>) -> Void) {
        let id = cityId ?? AppSettings.defaultCity.id
        var homeUrlComponents = baseUrlComponents
        homeUrlComponents.path = "/api/home-game"
        homeUrlComponents.queryItems = ([//?.append(
            URLQueryItem(name: "city_id", value: "\(id)")
        ])
        getStandard([HomeGame].self, with: homeUrlComponents, completion: completion)
    }
    
    //MARK:- Home Game by ID
    func getHomeGame(by id: Int, completion: @escaping (Result<HomeGame, SessionError>) -> Void) {
        var homeComps = baseUrlComponents
        homeComps.path = "/api/home-game/\(id)"
        getStandard(HomeGame.self, with: homeComps, completion: completion)
    }
    
    //MARK:- Get Game Info
    func getGameInfo(by id: Int, completion: @escaping (Result<GameInfo, SessionError>) -> Void) {
        var gameUrlComponents = baseUrlComponents
        gameUrlComponents.path = "/ajax/scope-game"
        gameUrlComponents.queryItems = [
            URLQueryItem(name: "id", value: "\(id)")
        ]
        get(GameInfo.self, with: gameUrlComponents, completion: completion)
    }
    
    //MARK:- Check Certificate
    func validateCertificate(forGameWithId id: Int, certificate: String, completion: @escaping (Result<CertificateResponse, SessionError>) -> Void) {
        var urlComps = baseUrlComponents
        urlComps.path = "/ajax/check-certificate"
        urlComps.queryItems = [
            URLQueryItem(name: "code", value: certificate),
            URLQueryItem(name: "game_id", value: "\(id)")
        ]
        get(CertificateResponse.self, with: urlComps, completion: completion)
    }
    
    //MARK:- Get Schedule
    func getSchedule(with filter: ScheduleFilter, completion: @escaping (Result<[GameShortInfo], SessionError>) -> Void) {
        var scheduleUrlComponents = baseUrlComponents
        scheduleUrlComponents.path = "/api/game"
        var queryItems = [URLQueryItem(name: "city_id", value: "\(filter.city.id)")]
        if let id = filter.date?.id {
            queryItems.append(URLQueryItem(name: "month", value: "\(id)"))
        }
        if let id = filter.format?.rawValue {
            queryItems.append(URLQueryItem(name: "format", value: "\(id)"))
        }
        if let id = filter.place?.id {
            queryItems.append(URLQueryItem(name: "place_id", value: "\(id)"))
        }
        if let id = filter.status?.id {
            queryItems.append(URLQueryItem(name: "status", value: "\(id)"))
        }
        if let id = filter.type?.id {
            queryItems.append(URLQueryItem(name: "type", value: "\(id)"))
        }
        scheduleUrlComponents.queryItems = queryItems
        
        getStandard(ScheduledGamesResponse.self, with: scheduleUrlComponents) { (getResult) in
            switch getResult {
            case let .failure(error):
                completion(.failure(error))
            case let .success(response):
                completion(.success(response.data))
            }
        }
    }
    
    //MARK:- Get Full Schedule
    ///Gets schedule and loads every game's detail info. Returns final full result with completion
    func getFullSchedule(with filter: ScheduleFilter, completion: @escaping (Result<[GameInfo], SessionError>) -> Void) {
        getSchedule(with: filter) { (result) in
            switch result {
            case let .failure(error):
                completion(.failure(error))
            case let .success(games):
                let group = DispatchGroup()
                var fullGames = [Int: GameInfo]()
                for game in games {
                    group.enter()
                    self.getGameInfo(by: game.id) { (result) in
                        switch result {
                        case let .failure(error):
                            completion(.failure(error))
                        case let .success(gameFullInfo):
                            var gameInfo = gameFullInfo
                            gameInfo.setShortInfo(game)
                            fullGames[game.id] = gameInfo
                        }
                        group.leave()
                    }
                }
                group.notify(queue: .main) {
                    let finalResult = games.map { fullGames[$0.id]! }
                    completion(.success(finalResult))
                }
            }
        }
    }
    
    //MARK:- Get Filter Options
    ///Used for filtering schedule
    ///- parameter cityId: Optionally request scoping the results for given city id
    func getFilterOptions(_ type: ScheduleFilterType, scopeFor cityId: Int? = nil, completion: @escaping (Result<[ScheduleFilterOption], SessionError>) -> Void) {
        var filterUrlComponents = baseUrlComponents
        filterUrlComponents.path = "/api/game/\(type.rawValue)"
        if let id = cityId {
            filterUrlComponents.queryItems = [
                URLQueryItem(name: "city_id", value: "\(id)")
            ]
        }
        getStandard([ScheduleFilterOption].self, with: filterUrlComponents, completion: completion)
    }
    
    //MARK:- Get Standard Server Request
    ///A get request for standard server response containing requested object in `data` field. You should mostly use this method rather than simple `get(:urlComponents:completion:)`.
    func getStandard<T: Decodable>(_ type: T.Type, with urlComponents: URLComponents, headers: [String: String]? = nil, authorizationKind: AuthorizationKind = .none, completion: @escaping ((Result<T, SessionError>) -> Void)) {
        get(ServerResponse<T>.self, with: urlComponents, headers: headers, authorizationKind: authorizationKind) { getResult in
            switch getResult {
            case let .failure(error):
                completion(.failure(error))
            case let .success(response):
                completion(.success(response.data))
            }
        }
    }
    
    func get<T: Decodable>(_ type: T.Type, apiPath: String, parameters: [String: String?], headers: [String: String]? = nil, authorizationKind: AuthorizationKind = .none, completion: @escaping ((Result<T, SessionError>) -> Void)) {
        var urlComponents = baseUrlComponents
        urlComponents.path = apiPath
        urlComponents.queryItems = parameters.map { URLQueryItem(name: $0, value: $1) }
        get(type, with: urlComponents, headers: headers, authorizationKind: authorizationKind, completion: completion)
    }
    
    //MARK:- Get Request
    ///- parameter authorizationKind: Use this parameter to choose authoriztion kind for the request. Auth info from this parameter will be used for 'Authoriztion' HTTP Header Field, so, if you provide `headers` with authoriztion header, it may be rewritten
    func get<Object: Decodable>(_ type: Object.Type, with urlComponents: URLComponents, headers: [String: String]? = nil, authorizationKind: AuthorizationKind = .none, completion: @escaping ((Result<Object, SessionError>) -> Void)) {
        guard let url = urlComponents.url else {
            completion(.failure(.invalidUrl))
            return
        }
        var request = URLRequest(url: url)
        for (key, value) in headers ?? [:] {
            request.setValue(value, forHTTPHeaderField: key)
        }
        if let auth = authorizationKind.header {
            request.setValue(auth.value, forHTTPHeaderField: auth.key)
        } else if authorizationKind != .none {
            completion(.failure(.invalidToken))
            return
        }
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 15
        print("""
        \n=====
        [\(Self.self).swift]
        Request: \(url)
        HTTP Method: \(request.httpMethod!)
        Headers: \(request.allHTTPHeaderFields ?? [:])
        =====\n\n
        """)
        let session = URLSession(configuration: config)
        session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(.other(error)))
                }
                return
            }
            
            let response = response as! HTTPURLResponse
            print("""
            \n=====
            [\(Self.self).swift]
            Response: \(url)
            Status Code: \(response.statusCode)
            """)
            guard response.statusCode == 200, let data = data else {
                print("""
                Error: either status code != 200, or data is nil
                =====\n\n
                """)
                DispatchQueue.main.async {
                    completion(.failure(.serverError(response.statusCode)))
                }
                return
            }
            print("""
            Body:
            \(String(data: data, encoding: .utf8) ?? "JSON error.")
            =====\n\n
            """)
            do {
                let object = try JSONDecoder().decode(Object.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(object))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(.decoding(error)))
                }
            }
        }.resume()
    }
    
    
    ///
    //MARK:- POST REQUESTS =======
    ///
    ///
    
    //MARK:- Push Subscribe
    func subscribePushOnGame(with id: String, completion: @escaping (Result<Bool, SessionError>) -> Void) {
        guard let auth = createBearerAuthHeader() else {
            completion(.failure(.invalidToken))
            return
        }
        let headers = [auth.key : auth.value]
        let params = ["game_id" : id]
        var urlComps = baseUrlComponents
        urlComps.path = "/api/game/subscribe-notification"
        afPostStandard(with: params, and: headers, to: urlComps, responseType: PushSubscribeResponse.self) { (postResult) in
            switch postResult {
            case let .failure(error):
                completion(.failure(error))
            case let .success(response):
                completion(.success(response.message == .subscribe))
            }
        }
    }
    
    
    //MARK:- Purchase Product
    func purchaseProduct(with id: String, deliveryMethod: DeliveryMethod, email: String, completion: @escaping (_ isSuccess: Bool) -> Void) {
        var urlComps = baseUrlComponents
        urlComps.path = "/api/order/buy"
        let params: [String : String] = [
            "product_id": id,
            "delivery_method": "\(deliveryMethod.id)",
            "email" : email,
            "city_id" : "\(AppSettings.defaultCity.id)"
        ]
        afPostBool(with: params, to: urlComps, completion: completion)
    }
    
    
    //MARK:- Check In On Game
    func checkInOnGame(with qrCode: String, chosenTeamId: Int, completion: @escaping (_ isSuccess: Bool) -> Void) {
        guard let auth = createBearerAuthHeader() else {
            completion(false)
            return
        }
        let headers = [auth.key : auth.value]
        let params = [
            "token": "\(qrCode)",
            "recordId": "\(chosenTeamId)"
        ]
        var urlComps = baseUrlComponents
        urlComps.path = "/api/game/check-qr"
        afPostBool(with: params, and: headers, to: urlComps, completion: completion)
    }
    
    //MARK:- Get Teams List From QR
    func getTeamsFromQR(_ qrCode: String, completion: @escaping (Result<[TeamInfo], SessionError>) -> Void) {
        guard let auth = createBearerAuthHeader() else {
            completion(.failure(.invalidToken))
            return
        }
        let headers = [auth.key : auth.value]
        let params = ["token" : "\(qrCode)"]
        var urlComps = baseUrlComponents
        urlComps.path = "/api/game/check-qr"
        afPostStandard(with: params, and: headers, to: urlComps, responseType: CheckInTeamsInfo.self) { (postResult) in
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
    
    //MARK:- Register
    func register(_ user: UserRegisterData, completion: @escaping (Result<RegisterResponse, SessionError>) -> Void) {
        var registerUrlComps = baseUrlComponents
        registerUrlComps.path = "/api/auth/register"
        let parameters = [
            "phone" : user.phone,
            "city_id": user.cityId
        ]
        afPostStandard(with: parameters, to: registerUrlComps, responseType: RegisterResponse.self, completion: completion)
    }
    
    //MARK:- Send SMS Code
    func sendCode(to number: String, completion: @escaping (_ isSuccess: Bool) -> Void) {
        var codeUrlComps = baseUrlComponents
        codeUrlComps.path = "/api/auth/token"
        let parameters = [
            "phone" : number
        ]
        afPostBool(with: parameters, to: codeUrlComps, completion: completion)
//        let userData = UserAuthData(phone: number)
//        post(userData, with: codeUrlComps) { (postResult) in
//            let isSuccess = (try? postResult.get()) != nil
//            completion(isSuccess)
//        }
    }
    
    //MARK:- Authenticate
    func authenticate(phoneNumber: String, smsCode: String, firebaseId: String,
                      completion: @escaping (Result<SavedAuthInfo, SessionError>) -> Void) {
        var authUrlComps = baseUrlComponents
        authUrlComps.path = "/api/auth/token"
        let parameters = [
            "phone" : phoneNumber,
            "code": smsCode
            //"device_id": firebaseId
        ]
        afPostAuth(with: parameters, to: authUrlComps, completion: completion)
    }
    
    //MARK:- Update User Token
    func updateToken(with refreshToken: String, completion: @escaping (Result<SavedAuthInfo, SessionError>) -> Void) {
        var tokenUrlComps = baseUrlComponents
        tokenUrlComps.path = "/api/auth/token"
        let params = [
            "refresh_token": refreshToken
        ]
        afPostAuth(with: params, to: tokenUrlComps, completion: completion)
    }
    
    //MARK:- Send Firebase ID
    func sendFirebaseId(_ fcmToken: String) {
        guard let auth = createBearerAuthHeader() else { return }
        let headers = [auth.key : auth.value]
        let params = ["device_id" : fcmToken]
        var urlComps = baseUrlComponents
        urlComps.path = "/api/device/create"
        afPostStandard(with: params, and: headers, to: urlComps, responseType: [String: String].self) { (postResult) in
            print("Firebase ID sending result:")
            print(postResult)
        }
    }
    
    //MARK:- Register on Game
    func registerOnGame(registerForm: RegisterForm, completion: @escaping (Result<GameOrderResponse, SessionError>) -> Void) {
        var registerUrlComps = baseUrlComponents
        registerUrlComps.path = "/ajax/save-record"
        
        let countPaidOnline = registerForm.countPaidOnline == nil ? nil : "\(registerForm.countPaidOnline!)"
        
        let parameters: [String: String?] = [
            //2 - регистрация через мобильное приложение
            "QpRecord[registration_type]"   : "2",
            "QpRecord[captainName]"         : registerForm.captainName,
            "QpRecord[email]"               : registerForm.email,
            "QpRecord[phone]"               : registerForm.phone,
            "QpRecord[comment]"             : registerForm.comment ?? "",
            "QpRecord[game_id]"             : "\(registerForm.gameId)",
            "QpRecord[first_time]"          : registerForm.isFirstTime ? "1" : "0",
            "certificates[]"                : registerForm.certificates,
            "QpRecord[payment_type]"        : "\(registerForm.paymentType.rawValue)",
            "QpRecord[count]"               : "\(registerForm.count)",
            "QpRecord[teamName]"            : registerForm.teamName,
            "QpRecord[payment_token]"       : registerForm.paymentToken,
            "QpRecord[surcharge]"           : countPaidOnline,
            "promo_code"                    : registerForm.promocode
        ]
        
        afPost(with: parameters, to: registerUrlComps, responseType: GameOrderResponse.self, completion: completion)
    }
    
    //MARK:- AF Post Auth
    ///Post request with response type of `SavedAuthInfo`
    func afPostAuth(with parameters: [String: String?], to urlComponents: URLComponents,
                    completion: @escaping ((Result<SavedAuthInfo, SessionError>) -> Void)) {
        afPostStandard(with: parameters, to: urlComponents, responseType: AuthInfoResponse.self) { (postResult) in
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
    
    //MARK:- Post with Bool completion
    ///Wraps server response to the success or failure. Use this method if you don't mind about data that is passed via response and you only want to know if the request was successul or not
    func afPostBool(with parameters: [String: String?], and headers: [String : String]? = nil,
                to urlComponents: URLComponents, completion: @escaping ((_ isSuccess: Bool) -> Void)) {
        afPostStandard(with: parameters, and: headers, to: urlComponents, responseType: [String : AnyValue?]?.self) { (postResult) in
            let isSuccess = (try? postResult.get()) != nil
            completion(isSuccess)
        }
    }
    
    //MARK:- AF Post Standard
    /// Makes POST request with afPost method, then wraps server reponse into the `ServerResponse<Response>` struct where `Response` type is passed via `responseType` parameter
    func afPostStandard<Response: Decodable>(with parameters: [String: String?], and headers: [String : String]? = nil,
                                             to urlComponents: URLComponents, responseType: Response.Type,
                                             completion: @escaping ((Result<Response, SessionError>) -> Void)) {
        
        afPost(with: parameters, and: headers, to: urlComponents, responseType: ServerResponse<Response>.self) { postResult in
            switch postResult {
            case let .failure(error):
                completion(.failure(error))
            case let .success(result):
                completion(.success(result.data))
            }
        }
    }
    
    //MARK:- Alamofire POST
    func afPost<Response: Decodable>(with parameters: [String: String?], and headers: [String : String]? = nil,
                                     to urlComponents: URLComponents, responseType: Response.Type,
                                     authorizationKind: AuthorizationKind = .none,
                                     completion: @escaping ((Result<Response, SessionError>) -> Void)) {
        
        var headers = headers ?? [:]
        if let auth = authorizationKind.header {
            headers[auth.key] = auth.value
        } else if authorizationKind != .none {
            completion(.failure(.invalidToken))
            return
        }
        let httpHeaders = headers.isEmpty ? nil : HTTPHeaders(headers)
        AF.upload(multipartFormData: { (multipartFormData) in
            for (key, value) in parameters {
                if let value = value {
                    multipartFormData.append(Data(value.utf8), withName: key)
                }
            }
        }, to: urlComponents, headers: httpHeaders)
        .responseData { (afResponse) in
            print("""
            \n=====
            [\(Self.self).swift]
            afPost Response: \(afResponse.response?.url as Any)
            Status Code: \(afResponse.response?.statusCode as Any)
            """)
            switch afResponse.result {
            case let .failure(error):
                print("Error: \(error)")
                completion(.failure(.other(error)))
            case let .success(data):
                print("Body:")
                print(String(data: data, encoding: .utf8) ?? "json decoding error")
                do {
                    let serverResponse = try JSONDecoder().decode(Response.self, from: data)
                    completion(.success(serverResponse))
                } catch {
                    completion(.failure(.decoding(error)))
                }
            }
            print("=====\n\n")
        }
        print("""
        \n=====
        [\(Self.self).swift]
        afPost request: \(urlComponents.url as Any)
        Headers: \(headers)
        Body parameters: \(parameters)
        =====\n\n
        """)
    }
    
    //MARK:- Post with decoding response
    ///Response decoding is performed on the main queue
    func post<Object: Encodable, Response: Decodable>(_ object: Object, with urlComponents: URLComponents, reponseType: Response.Type, completion: @escaping ((Result<Response, SessionError>) -> Void)) {
        post(object, with: urlComponents) { (postResult) in
            switch postResult {
            case let .failure(error):
                completion(.failure(error))
            case let .success(data):
                do {
                    let object = try JSONDecoder().decode(reponseType, from: data)
                    completion(.success(object))
                } catch {
                    completion(.failure(.decoding(error)))
                }
            }
        }
    }
    
    //MARK:- Post object
    ///Completion is performed on the main queue
    func post<Object: Encodable>(_ object: Object, with urlComponents: URLComponents, completion: @escaping ((Result<Data, SessionError>) -> Void)) {
        do {
            let data = try JSONEncoder().encode(object)
            post(data, with: urlComponents, completion: completion)
        }
        catch {
            completion(.failure(.other(error)))
        }
    }
    
    
    //MARK:- POST Request
    ///Completion is performed on the main queue
    func post(_ data: Data, with urlComponents: URLComponents, authorizationKind: AuthorizationKind, completion: @escaping ((Result<Data, SessionError>) -> Void)) {
        guard let url = urlComponents.url else {
            completion(.failure(.invalidUrl))
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("multipart/form-data", forHTTPHeaderField: "Content-Type")
        request.httpBody = data
        print("""
        \n=====
        [\(Self.self).swift]
        Request: \(url)
        HTTP Method: \(request.httpMethod!)
        Headers: \(request.allHTTPHeaderFields ?? [:])
        =====\n\n
        """)
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(.other(error)))
                }
                return
            }
            
            let response = response as! HTTPURLResponse
            print("""
            \n=====
            [\(Self.self).swift]
            Response: \(url)
            Status Code: \(response.statusCode)
            """)
            guard let data = data else {
                print("Error. HTTP Response: \(response)")
                print("=====\n\n")
                DispatchQueue.main.async {
                    completion(.failure(.serverError(response.statusCode)))
                }
                return
            }
            print("""
            Body:
            \(String(data: data, encoding: .utf8) ?? "JSON error.")
            =====\n\n
            """)
            DispatchQueue.main.async {
                completion(.success(data))
            }
        }.resume()
    }
}
