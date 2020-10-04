//
//  NetworkService.swift
//  QuizPlease
//
//  Created by Владислав on 27.08.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import Foundation

class NetworkService {
    private init() {}
    
    static let shared = NetworkService()
    
    
    ///
    //MARK:- GET REQUESTS =======
    ///
    ///
    
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
    func getRating(cityId: Int, teamName: String, league: Int, ratingScope: Int, completion: @escaping (Result<[RatingItem], SessionError>) -> Void) {
        var ratingUrlComponents = Globals.baseUrl
        ratingUrlComponents.path = "/api/rating"
        ratingUrlComponents.queryItems = ([//?.append(contentsOf: [
            URLQueryItem(name: "city_id", value: "\(cityId)"),
            URLQueryItem(name: "league", value: "\(league)"),
            URLQueryItem(name: "general", value: "\(ratingScope)")
        ])
        if teamName.count > 0 {
            ratingUrlComponents.queryItems?.append(URLQueryItem(name: "teamName", value: teamName))
        }
        
        getStandard([RatingItem].self, with: ratingUrlComponents) { (getResult) in
            completion(getResult)
        }
        
    }
    
    //MARK:- Get Shop Items
    func getShopItems(completion: @escaping (Result<[ShopItem], SessionError>) -> Void) {
        var shopUrlComponents = Globals.baseUrl
        shopUrlComponents.path = "/api/product"
        
        getStandard([ShopItem].self, with: shopUrlComponents) { (getResult) in
            completion(getResult)
        }
    }
    
    //MARK:- Home Games
    ///- parameter cityId: Optional city parameter. If `nil`, user's `defaultCity` is used.
    func getHomeGames(cityId: Int? = nil, completion: @escaping (Result<[HomeGame], SessionError>) -> Void) {
        let id = cityId ?? Globals.defaultCity.id
        var homeUrlComponents = Globals.baseUrl
        homeUrlComponents.path = "/api/home-game"
        homeUrlComponents.queryItems = ([//?.append(
            URLQueryItem(name: "city_id", value: "\(id)")
        ])
        getStandard([HomeGame].self, with: homeUrlComponents) { (getResult) in
            completion(getResult)
        }
    }
    
    func getHomeGame(by id: Int, completion: @escaping (Result<HomeGame, SessionError>) -> Void) {
        var homeComps = Globals.baseUrl
        homeComps.path = "/api/home-game/\(id)"
        getStandard(HomeGame.self, with: homeComps) { (getResult) in
            completion(getResult)
        }
    }
    
    //MARK:- Get Game Info
    func getGameInfo(by id: Int, completion: @escaping (Result<GameInfo, SessionError>) -> Void) {
        var gameUrlComponents = Globals.baseUrl
        gameUrlComponents.path = "/ajax/scope-game"
        gameUrlComponents.queryItems = ([//?.append(
            URLQueryItem(name: "id", value: "\(id)")
        ])
        get(GameInfo.self, with: gameUrlComponents) { (getResult) in
            completion(getResult)
        }
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
        getStandard([ScheduleFilterOption].self, with: filterUrlComponents) { completion($0) }
        
    }
    
    //MARK:- Get Standard Server Request
    ///A get request for standard server response containing requested object in `data` field. You should mostly use this method rather than simple `get(:urlComponents:completion:)`.
    func getStandard<T: Decodable>(_ type: T.Type, with urlComponents: URLComponents, completion: @escaping ((Result<T, SessionError>) -> Void)) {
        get(ServerResponse<T>.self, with: urlComponents) { getResult in
            switch getResult {
            case let .failure(error):
                completion(.failure(error))
            case let .success(response):
                completion(.success(response.data))
            }
        }
    }
    
    //MARK:- Get Request
    func get<T: Decodable>(_ type: T.Type, with urlComponents: URLComponents, completion: @escaping ((Result<T, SessionError>) -> Void)) {
        guard let url = urlComponents.url else {
            completion(.failure(.invalidUrl))
            return
        }
        print(url)
        URLSession.shared.dataTask(with: url) { (data, response, error) in
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
            
//            let json = try! JSONSerialization.jsonObject(with: data, options: .allowFragments)
//            print(json)
            
            do {
                let object = try JSONDecoder().decode(T.self, from: data)
                
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
    
    
    //MARK:- Check In On Game
    func checkInOnGame(with qrCode: String, chosenTeamId: Int, completion: @escaping (_ isSuccess: Bool) -> Void) {
        let info = CheckInData(token: qrCode, recordId: chosenTeamId)
        var urlComps = Globals.baseUrl
        urlComps.path = "/api/game/check-qr"
        post(info, with: urlComps) { (postResult) in
            let isSuccess = (try? postResult.get()) != nil
            completion(isSuccess)
        }
    }
    
    //MARK:- Get Teams List From QR
    func getTeamsFromQR(_ qrCode: String, completion: @escaping (Result<[TeamInfo], SessionError>) -> Void) {
        let info = CheckInData(token: qrCode)
        var urlComps = Globals.baseUrl
        urlComps.path = "/api/game/check-qr"
        post(info, with: urlComps, reponseType: CheckInTeamsInfo.self) { (postResult) in
            switch postResult {
            case let .failure(error):
                completion(.failure(error))
            case let .success(response):
                if let teams = response.records, teams.count > 0 {
                    completion(.success(teams))
                } else {
                    completion(.failure(.jsonError))
                }
            }
        }
    }
    
    //MARK:- Register
    func register(_ user: UserRegisterData, completion: @escaping (Result<RegisterResponse, SessionError>) -> Void) {
        var registerUrlComps = Globals.baseUrl
        registerUrlComps.path = "/api/auth/register"
        post(user, with: registerUrlComps, reponseType: RegisterResponse.self, completion: completion)
    }
    
    //MARK:- Send SMS Code
    func sendCode(to number: String, completion: @escaping (_ isSuccess: Bool) -> Void) {
        var codeUrlComps = Globals.baseUrl
        codeUrlComps.path = "/api/auth/token"
        let userData = UserAuthData(phone: number)
        post(userData, with: codeUrlComps) { (postResult) in
            let isSuccess = (try? postResult.get()) != nil
            completion(isSuccess)
        }
    }
    
    //MARK:- Authenticate
    func authenticate(phoneNumber: String, smsCode: String, firebaseId: String,
                      completion: @escaping (Result<AuthResponse, SessionError>) -> Void) {
        var authUrlComps = Globals.baseUrl
        authUrlComps.path = "/api/auth/token"
        let userData = UserAuthData(phone: phoneNumber, code: smsCode, device_id: firebaseId)
        post(userData, with: authUrlComps, reponseType: AuthResponse.self, completion: completion)
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
