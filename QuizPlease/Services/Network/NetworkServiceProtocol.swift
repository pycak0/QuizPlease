//
//  NetworkServiceProtocol.swift
//  QuizPlease
//
//  Created by Владислав on 14.04.2023.
//  Copyright © 2023 Владислав. All rights reserved.
//

import Foundation

protocol NetworkServiceProtocol {

    @discardableResult
    // swiftlint:disable:next function_parameter_count
    func get<T: Decodable>(
        _ type: T.Type,
        apiPath: String,
        parameters: [String: String?],
        headers: [String: String]?,
        authorizationKind: NetworkService.AuthorizationKind,
        completion: @escaping ((Result<T, NetworkServiceError>) -> Void)
    ) -> Cancellable?

    /// - parameter apiPath: used to constructs URLComponents using `baseUrlComponents` and given path
    func afPost<Response: Decodable>(
        with bodyParameters: [String: String?],
        and headers: [String: String]?,
        to apiPath: String,
        responseType: Response.Type,
        authorizationKind: NetworkService.AuthorizationKind,
        completion: @escaping (Result<Response, NetworkServiceError>) -> Void
    )
}

extension NetworkServiceProtocol {

    @discardableResult
    func get<T: Decodable>(
        _ type: T.Type,
        apiPath: String,
        parameters: [String: String?],
        completion: @escaping ((Result<T, NetworkServiceError>) -> Void)
    ) -> Cancellable? {
        get(
            type,
            apiPath: apiPath,
            parameters: parameters,
            headers: nil,
            authorizationKind: .none,
            completion: completion
        )
    }

    /// - parameter apiPath: used to constructs URLComponents using `baseUrlComponents` and given path
    func afPost<Response: Decodable>(
        with bodyParameters: [String: String?],
        to apiPath: String,
        responseType: Response.Type,
        completion: @escaping (Result<Response, NetworkServiceError>) -> Void
    ) {
        afPost(
            with: bodyParameters,
            and: nil,
            to: apiPath,
            responseType: responseType,
            authorizationKind: .none,
            completion: completion
        )
    }
}

extension NetworkService: NetworkServiceProtocol { }
