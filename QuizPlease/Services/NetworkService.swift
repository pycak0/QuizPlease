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
    
//    enum RequestType {
//        case city
//        init?<T: Decodable>(type: T.Type) {
//            switch String(describing: type) {
//            case "\(CityResponse.self)":
//                self = .city
//            default:
//                return nil
//            }
//        }
//    }
    
    private func apiPath<T: Decodable>(_ t: T.Type) -> String {
        switch String(describing: t) {
        case "\(CityResponse.self)":
            return "/api/city"
        default:
            return ""
        }
        
    }
    
    //MARK:- Get Request
    func get<T: Decodable>(of type: T.Type, completion: @escaping ((Result<T, SessionError>) -> Void)) {
        var urlComponents = Globals.baseUrl
        urlComponents.path = apiPath(type)
        guard let url = urlComponents.url else {
            completion(.failure(.invalidUrl))
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(.other(error)))
                }
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200,
                let data = data
            else {
                DispatchQueue.main.async {
                    completion(.failure(.serverError))
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
            
        }
    }
    
}
