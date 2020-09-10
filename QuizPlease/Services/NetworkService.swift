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
    
    //MARK:- Get Cities
    func getCities(completion: @escaping (Result<[City], SessionError>) -> Void) {
        var cityUrlComponents = Globals.baseUrl
        cityUrlComponents.path = "/api/city"
        
        getStandard(CityResponse.self, urlComponents: cityUrlComponents) { (getResult) in
            switch getResult {
            case let .failure(error):
                completion(.failure(error))
            case let .success(cityResponse):
                completion(.success(cityResponse.data))
            }
        }
    }
    
    //MARK:- Get Rating
    func getRating(cityId: Int, teamName: String, league: Int, ratingScope: Int, completion: @escaping (Result<[RatingItem], SessionError>) -> Void) {
        var ratingUrlComponents = Globals.baseUrl
        ratingUrlComponents.path = "/api/rating"
        ratingUrlComponents.queryItems?.append(contentsOf: [
            URLQueryItem(name: "city_id", value: "\(cityId)"),
            URLQueryItem(name: "league", value: "\(league)"),
            URLQueryItem(name: "general", value: "\(ratingScope)")
        ])
        if teamName.count > 0 {
            ratingUrlComponents.queryItems?.append(URLQueryItem(name: "teamName", value: teamName))
        }
        
        getStandard([RatingItem].self, urlComponents: ratingUrlComponents) { (getResult) in
            completion(getResult)
        }
        
    }
    
    //MARK:- Get Game Info
    func getGameInfo(by id: Int, completion: @escaping (Result<GameInfo, SessionError>) -> Void) {
        var gameUrlComponents = Globals.baseUrl
        gameUrlComponents.path = "/ajax/scope-game"
        gameUrlComponents.queryItems?.append(URLQueryItem(name: "id", value: "\(id)"))
        get(GameInfo.self, urlComponents: gameUrlComponents) { (getResult) in
            completion(getResult)
        }
    }
    
    //MARK:- Get Schedule
    func getSchedule(with filter: ScheduleFilter, completion: @escaping (Result<[GameShortInfo], SessionError>) -> Void) {
        var scheduleUrlComponents = Globals.baseUrl
        scheduleUrlComponents.path = "/api/game"
        scheduleUrlComponents.queryItems?.append(contentsOf: [
            URLQueryItem(name: "city_id", value: "\(filter.city.id)")
        ])
        getStandard(ScheduledGamesResponse.self, urlComponents: scheduleUrlComponents) { (getResult) in
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
    func getFilterOptions<FilterType: ScheduleFilterProtocol>(_ type: FilterType.Type, scopeFor cityId: Int? = nil, completion: @escaping (Result<[FilterType], SessionError>) -> Void) {
        var filterUrlComponents = Globals.baseUrl
        filterUrlComponents.path = "/api/game/\(type.apiName)"
        if let id = cityId {
            filterUrlComponents.queryItems?.append(URLQueryItem(name: "city_id", value: "\(id)"))
        }
        getStandard([FilterType].self, urlComponents: filterUrlComponents) { completion($0) }
        
    }
    
    //MARK:- Get Standard Server Request
    ///A get request for standard server response containing requested object in `data` field. You should mostly use this method rather than simple `get(:urlComponents:completion:)`.
    func getStandard<T: Decodable>(_ type: T.Type, urlComponents: URLComponents, completion: @escaping ((Result<T, SessionError>) -> Void)) {
        get(ServerResponse<T>.self, urlComponents: urlComponents) { getResult in
            switch getResult {
            case let .failure(error):
                completion(.failure(error))
            case let .success(response):
                completion(.success(response.data))
            }
        }
    }
    
    //MARK:- Get Request
    func get<T: Decodable>(_ type: T.Type, urlComponents: URLComponents, completion: @escaping ((Result<T, SessionError>) -> Void)) {
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
    
}
