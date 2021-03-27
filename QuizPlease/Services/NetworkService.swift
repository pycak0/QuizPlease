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
    
    static let shared = NetworkService()
        
    ///
    //MARK:- GET REQUESTS =======
    ///
    ///
    
    //MARK:- User Info
    func getUserInfo(completion: @escaping ((Result<UserInfo, SessionError>) -> Void)) {
        guard let token = Globals.userToken else {
            completion(.failure(.invalidToken))
            return
        }
        var userUrlComps = Globals.baseUrl
        userUrlComps.path = "/api/users/current"
        let headers: [String: String] = [
            "Authorization" : "Bearer \(token)"
        ]
        getStandard(UserInfo.self, with: userUrlComps, headers: headers, completion: completion)
    }
        
    //MARK:- Get Cities
    func getCities(completion: @escaping (Result<[City], SessionError>) -> Void) {
        var cityUrlComponents = Globals.baseUrl
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
        var warmupUrlComps = Globals.baseUrl
        warmupUrlComps.path = "/api/warmup-question"
        
        getStandard([WarmupQuestion].self, with: warmupUrlComps, completion: completion)
    }
    
    //MARK:- Get Rating
    func getRating(cityId: Int, teamName: String, league: Int, ratingScope: Int, page: Int, completion: @escaping (Result<[RatingItem], SessionError>) -> Void) {
        var ratingUrlComponents = Globals.baseUrl
        ratingUrlComponents.path = "/api/rating"
        ratingUrlComponents.queryItems = ([//?.append(contentsOf: [
            URLQueryItem(name: "city_id", value: "\(cityId)"),
            URLQueryItem(name: "league", value: "\(league)"),
            URLQueryItem(name: "general", value: "\(ratingScope)"),
            URLQueryItem(name: "page", value: "\(page)")
        ])
        if teamName.count > 0 {
            ratingUrlComponents.queryItems?.append(URLQueryItem(name: "teamName", value: teamName))
        }
        
        getStandard([RatingItem].self, with: ratingUrlComponents, completion: completion)
        
    }
    
    //MARK:- Get Shop Items
    func getShopItems(cityId: Int? = nil, completion: @escaping (Result<[ShopItem], SessionError>) -> Void) {
        var shopUrlComponents = Globals.baseUrl
        shopUrlComponents.path = "/api/product"
        
        let id = cityId ?? Globals.defaultCity.id
        shopUrlComponents.queryItems = [
            URLQueryItem(name: "city_id", value: "\(id)")
        ]
        
        getStandard([ShopItem].self, with: shopUrlComponents, completion: completion)
    }
    
    //MARK:- Home Games List
    ///- parameter cityId: Optional city parameter. If `nil`, user's `defaultCity` is used.
    func getHomeGames(cityId: Int? = nil, completion: @escaping (Result<[HomeGame], SessionError>) -> Void) {
        let id = cityId ?? Globals.defaultCity.id
        var homeUrlComponents = Globals.baseUrl
        homeUrlComponents.path = "/api/home-game"
        homeUrlComponents.queryItems = ([//?.append(
            URLQueryItem(name: "city_id", value: "\(id)")
        ])
        getStandard([HomeGame].self, with: homeUrlComponents, completion: completion)
    }
    
    //MARK:- Home Game by ID
    func getHomeGame(by id: Int, completion: @escaping (Result<HomeGame, SessionError>) -> Void) {
        var homeComps = Globals.baseUrl
        homeComps.path = "/api/home-game/\(id)"
        getStandard(HomeGame.self, with: homeComps, completion: completion)
    }
    
    //MARK:- Get Game Info
    func getGameInfo(by id: Int, completion: @escaping (Result<GameInfo, SessionError>) -> Void) {
        var gameUrlComponents = Globals.baseUrl
        gameUrlComponents.path = "/ajax/scope-game"
        gameUrlComponents.queryItems = ([//?.append(
            URLQueryItem(name: "id", value: "\(id)")
        ])
        get(GameInfo.self, with: gameUrlComponents, completion: completion)
    }
    
    func validateCertificate(forGameWithId id: Int, certificate: String, completion: @escaping (Result<CertificateResponse, SessionError>) -> Void) {
        var urlComps = Globals.baseUrl
        urlComps.path = "/ajax/check-certificate"
        urlComps.queryItems = [
            URLQueryItem(name: "code", value: certificate),
            URLQueryItem(name: "game_id", value: "\(id)")
        ]
        get(CertificateResponse.self, with: urlComps, completion: completion)
    }
    
    //MARK:- Get Schedule
    func getSchedule(with filter: ScheduleFilter, completion: @escaping (Result<[GameShortInfo], SessionError>) -> Void) {
        var scheduleUrlComponents = Globals.baseUrl
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
        scheduleUrlComponents.queryItems = queryItems //?.append(contentsOf: queryItems)
        
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
        var filterUrlComponents = Globals.baseUrl
        filterUrlComponents.path = "/api/game/\(type.rawValue)"
        if let id = cityId {
            filterUrlComponents.queryItems = ([//?.append(
                URLQueryItem(name: "city_id", value: "\(id)")
            ])
        }
        getStandard([ScheduleFilterOption].self, with: filterUrlComponents, completion: completion)
        
    }
    
    //MARK:- Get Standard Server Request
    ///A get request for standard server response containing requested object in `data` field. You should mostly use this method rather than simple `get(:urlComponents:completion:)`.
    func getStandard<T: Decodable>(_ type: T.Type, with urlComponents: URLComponents, headers: [String: String]? = nil, completion: @escaping ((Result<T, SessionError>) -> Void)) {
        get(ServerResponse<T>.self, with: urlComponents, headers: headers) { getResult in
            switch getResult {
            case let .failure(error):
                completion(.failure(error))
            case let .success(response):
                completion(.success(response.data))
            }
        }
    }
    
    //MARK:- Get Request
    func get<T: Decodable>(_ type: T.Type, with urlComponents: URLComponents, headers: [String: String]? = nil, completion: @escaping ((Result<T, SessionError>) -> Void)) {
        guard let url = urlComponents.url else {
            completion(.failure(.invalidUrl))
            return
        }
        print(url)
        var request = URLRequest(url: url)
        for (key, value) in headers ?? [:] {
            request.setValue(value, forHTTPHeaderField: key)
        }
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 15
        let session = URLSession(configuration: config)
        session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(.other(error)))
                }
                return
            }
            
            let response = response as! HTTPURLResponse
            guard response.statusCode == 200, let data = data else {
                DispatchQueue.main.async {
                    completion(.failure(.serverError(response.statusCode)))
                }
                return
            }
            
            do {
                let object = try JSONDecoder().decode(T.self, from: data)
                
                DispatchQueue.main.async {
                    completion(.success(object))
                }
//                guard let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) else { return }
//                print(">>> Received data:\n\n\n", json)
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(.decoding(error)))
                }
                guard let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) else { return }
                print(">>> Received data:\n\n\n", json)
            }
            
        }.resume()
    }
    
    
    ///
    //MARK:- POST REQUESTS =======
    ///
    ///
    
    //MARK:- Push Subscribe
    ///Completion `nil` value means that some errors occured on server side
    func subscribePushOnGame(with id: String, completion: @escaping (_ isSubscribe: Bool?) -> Void) {
        guard let token = Globals.userToken else {
            completion(nil)
            return
        }
        var urlComps = Globals.baseUrl
        urlComps.path = "/api/game/subscribe-notification"
        let params = [
            "game_id" : id,
            //"subscribe" : isSubscribe ? "1" : "0"
        ]
        let headers = ["Authorization" : "Bearer \(token)"]
        afPostStandard(with: params, and: headers, to: urlComps, responseType: PushSubscribeResponse.self) { (postResult) in
            switch postResult {
            case let .failure(error):
                print(error)
                completion(nil)
            case let .success(response):
                completion(response.message == .subscribe)
            }
        }
    }
    
    
    //MARK:- Purchase Product
    func purchaseProduct(with id: String, deliveryMethod: DeliveryMethod, email: String, completion: @escaping (_ isSuccess: Bool) -> Void) {
        var urlComps = Globals.baseUrl
        urlComps.path = "/api/order/buy"
        
        let params: [String : String] = [
            "product_id": id,
            "delivery_method": "\(deliveryMethod.id)",
            "email" : email
        ]
        
        afPostBool(with: params, to: urlComps, completion: completion)
    }
    
    
    //MARK:- Check In On Game
    func checkInOnGame(with qrCode: String, chosenTeamId: Int, completion: @escaping (_ isSuccess: Bool) -> Void) {
        guard let userToken = Globals.userToken else {
            completion(false)
            return
        }
        var urlComps = Globals.baseUrl
        urlComps.path = "/api/game/check-qr"
        let params = [
            "token": "\(qrCode)",
            "recordId": "\(chosenTeamId)"
        ]
        let headers = ["Authorization" : "Bearer \(userToken)"]
        afPostBool(with: params, and: headers, to: urlComps, completion: completion)
    }
    
    //MARK:- Get Teams List From QR
    func getTeamsFromQR(_ qrCode: String, completion: @escaping (Result<[TeamInfo], SessionError>) -> Void) {
        guard let userToken = Globals.userToken else {
            completion(.failure(.invalidToken))
            return
        }
        var urlComps = Globals.baseUrl
        urlComps.path = "/api/game/check-qr"
        let params = ["token" : "\(qrCode)"]
        let headers = ["Authorization" : "Bearer \(userToken)"]
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
        var registerUrlComps = Globals.baseUrl
        registerUrlComps.path = "/api/auth/register"
        let parameters = [
            "phone" : user.phone,
            "city_id": user.cityId
        ]
        afPostStandard(with: parameters, to: registerUrlComps, responseType: RegisterResponse.self, completion: completion)
    }
    
    //MARK:- Send SMS Code
    func sendCode(to number: String, completion: @escaping (_ isSuccess: Bool) -> Void) {
        var codeUrlComps = Globals.baseUrl
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
        var authUrlComps = Globals.baseUrl
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
        var tokenUrlComps = Globals.baseUrl
        tokenUrlComps.path = "/api/auth/token"
        let params = [
            "refresh_token": refreshToken
        ]
        afPostAuth(with: params, to: tokenUrlComps, completion: completion)
    }
    
    //MARK:- Send Firebase ID
    func sendFirebaseId(_ fcmToken: String) {
        guard let userToken = Globals.userToken else { return }
        var urlComps = Globals.baseUrl
        urlComps.path = "/api/device/create"
        let params = ["device_id" : fcmToken]
        let headers = ["Authorization" : "Bearer \(userToken)"]
        afPostStandard(with: params, and: headers, to: urlComps, responseType: [String: String].self) { (postResult) in
            print("Firebase ID sending result:")
            print(postResult)
        }
    }
    
    //MARK:- Register on Game
    func registerOnGame(registerForm: RegisterForm, completion: @escaping (Result<GameOrderResponse, SessionError>) -> Void) {
        var registerUrlComps = Globals.baseUrl
        registerUrlComps.path = "/ajax/save-record"
        
        let countPaidOnline = registerForm.countPaidOnline == nil ? nil : "\(registerForm.countPaidOnline!)"
        
        let parameters: [String: String?] = [
            "QpRecord[captainName]"     : registerForm.captainName,
            "QpRecord[email]"           : registerForm.email,
            "QpRecord[phone]"           : registerForm.phone,
            "QpRecord[comment]"         : registerForm.comment ?? "",
            "QpRecord[game_id]"         : "\(registerForm.gameId)",
            "QpRecord[first_time]"      : registerForm.isFirstTime ? "1" : "0",
            "certificates[]"            : registerForm.certificates,
            "QpRecord[payment_type]"    : registerForm.paymentType == .online ? "1" : "2",
            "QpRecord[count]"           : "\(registerForm.count)",
            "QpRecord[teamName]"        : registerForm.teamName,
            "QpRecord[payment_token]"   : registerForm.paymentToken,
            "QpRecord[surcharge]"       : countPaidOnline,
            "promo_code"                : registerForm.promocode
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
                                     completion: @escaping ((Result<Response, SessionError>) -> Void)) {
        
        let httpHeaders = headers != nil ? HTTPHeaders(headers!) : nil
        AF.upload(multipartFormData: { (multipartFormData) in
            for (key, value) in parameters {
                if let value = value {
                    multipartFormData.append(Data(value.utf8), withName: key)
                }
            }
        }, to: urlComponents, headers: httpHeaders)
        .responseData { (afResponse) in
            switch afResponse.result {
            case let .failure(error):
                completion(.failure(.other(error)))
            case let .success(data):
                do {
                    let serverResponse = try JSONDecoder().decode(Response.self, from: data)
                    print(">>> Response data:\n\n", String(data: data, encoding: .utf8) ?? "json decoding error")
                    completion(.success(serverResponse))
                } catch {
                    completion(.failure(.decoding(error)))
                    
                    print(">>> Response data:\n\n", String(data: data, encoding: .utf8) ?? "json decoding error")
                }
            }
        }
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
    func post(_ data: Data, with urlComponents: URLComponents, completion: @escaping ((Result<Data, SessionError>) -> Void)) {
        guard let url = urlComponents.url else {
            completion(.failure(.invalidUrl))
            return
        }
        print(url)
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("multipart/form-data", forHTTPHeaderField: "Content-Type")
        request.httpBody = data
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(.other(error)))
                }
                return
            }
            
            let response = response as! HTTPURLResponse
            guard let data = data,
                  let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments)
            else {
                DispatchQueue.main.async {
                    completion(.failure(.serverError(response.statusCode)))
                }
                return
            }
            
            print(json)
            
            DispatchQueue.main.async {
                completion(.success(data))
            }
        }.resume()
        
    }
    
}
