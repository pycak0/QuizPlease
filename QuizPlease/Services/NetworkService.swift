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
        
        get(CityResponse.self, urlComponents: cityUrlComponents) { (getResult) in
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
        
        get([RatingItem].self, urlComponents: ratingUrlComponents) { (getResult) in
            completion(getResult)
        }
        
    }
    
    //MARK:- Available Time
    ///Used for filtering schedule
    func getFilterList(_ type: ScheduleFilterType, completion: @escaping (Result<[String], SessionError>) -> Void) {
        var timeUrlComponents = Globals.baseUrl
        timeUrlComponents.path = "/api/game/\(type.rawValue)"
        
        get([String].self, urlComponents: timeUrlComponents) { (getResult) in
            completion(getResult)
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
            
            guard let serverResponse = try? JSONDecoder().decode(ServerResponse<T>.self, from: data) else {
                DispatchQueue.main.async {
                    completion(.failure(.jsonError))
                }
                return
            }
            
            DispatchQueue.main.async {
                completion(.success(serverResponse.data))
            }
            
        }.resume()
    }
    
}
