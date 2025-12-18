//
//  NetworkServiceProtocol.swift
//  QuizPlease
//
//  Created by Владислав on 14.04.2023.
//  Copyright © 2023 Владислав. All rights reserved.
//

import Foundation

/// A protocol defining an abstraction for executing network requests and handling responses.
///
/// `NetworkServiceProtocol` provides a set of methods for performing HTTP network operations,
/// including GET and POST requests, with support for custom parameters, headers, authorization,
/// and various response/result handling mechanisms.
///
/// Implementors of this protocol should support:
/// - Sending GET requests with query parameters and headers.
/// - Sending POST requests with either dictionary body parameters or multipart form data objects.
/// - Encoding request payloads using `Encodable`.
/// - Decoding responses into types conforming to `Decodable`.
/// - Specifying custom authorization mechanisms.
/// - Performing actions asynchronously, with completion handlers returning a `Result`.
///
/// Typical usage involves calling the desired method with the appropriate parameters,
/// and handling the result in the provided completion handler.
///
/// Implementations may return a `Cancellable` object allowing the caller to cancel ongoing requests,
/// where supported.
protocol NetworkServiceProtocol {

    // swiftlint:disable function_parameter_count
    @discardableResult
    func get<T: Decodable>(
        _ type: T.Type,
        apiPath: String,
        parameters: [String: String?]?,
        headers: [String: String]?,
        authorizationKind: NetworkService.AuthorizationKind,
        completion: @escaping ((Result<T, NetworkServiceError>) -> Void)
    ) -> Cancellable?

    /// - parameter apiPath: used to constructs URLComponents using `baseUrlComponents` and given path
    func afPost<Response: Decodable>(
        with bodyParameters: [String: String?],
        queryParameters: [String: String?]?,
        and headers: [String: String]?,
        to apiPath: String,
        responseType: Response.Type,
        authorizationKind: NetworkService.AuthorizationKind,
        completion: @escaping (Result<Response, NetworkServiceError>) -> Void
    )

    /// - parameter apiPath: used to constructs URLComponents using `baseUrlComponents` and given path
    func afPost<Response: Decodable>(
        with multipartFormDataObjects: MultipartFormDataObjects,
        queryParameters: [String: String?]?,
        and headers: [String: String]?,
        to apiPath: String,
        responseType: Response.Type,
        authorizationKind: NetworkService.AuthorizationKind,
        completion: @escaping (Result<Response, NetworkServiceError>) -> Void
    )

    @discardableResult
    func post<Object: Encodable, Response: Decodable>(
        _ object: Object,
        apiPath: String,
        parameters: [String: String?]?,
        headers: [String: String]?,
        authorizationKind: NetworkService.AuthorizationKind,
        reponseType: Response.Type,
        completion: @escaping ((Result<Response, NetworkServiceError>) -> Void)
    ) -> Cancellable?
    // swiftlint:enable function_parameter_count
}

extension NetworkServiceProtocol {

    @discardableResult
    func get<T: Decodable>(
        _ type: T.Type,
        apiPath: String,
        parameters: [String: String?]?,
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

    /// - parameter apiPath: used to constructs URLComponents using `baseUrlComponents` and given path
    func afPost<Response: Decodable>(
        with multipartFormDataObjects: MultipartFormDataObjects,
        to apiPath: String,
        responseType: Response.Type,
        completion: @escaping (Result<Response, NetworkServiceError>) -> Void
    ) {
        afPost(
            with: multipartFormDataObjects,
            queryParameters: nil,
            and: nil,
            to: apiPath,
            responseType: responseType,
            authorizationKind: .none,
            completion: completion
        )
    }

    /// - parameter apiPath: used to constructs URLComponents using `baseUrlComponents` and given path
    func afPost<Response: Decodable>(
        with bodyParameters: [String: String?],
        and headers: [String: String]?,
        to apiPath: String,
        responseType: Response.Type,
        authorizationKind: NetworkService.AuthorizationKind,
        completion: @escaping (Result<Response, NetworkServiceError>) -> Void
    ) {
        afPost(
            with: bodyParameters,
            queryParameters: nil,
            and: headers,
            to: apiPath,
            responseType: responseType,
            authorizationKind: authorizationKind,
            completion: completion
        )
    }

    /// - parameter apiPath: used to constructs URLComponents using `baseUrlComponents` and given path
    func afPost<Response: Decodable>(
        with multipartFormDataObjects: MultipartFormDataObjects,
        queryParameters: [String: String?]?,
        and headers: [String: String]?,
        to apiPath: String,
        responseType: Response.Type,
        authorizationKind: NetworkService.AuthorizationKind,
        completion: @escaping (Result<Response, NetworkServiceError>) -> Void
    ) {
        afPost(
            with: multipartFormDataObjects,
            queryParameters: nil,
            and: nil,
            to: apiPath,
            responseType: responseType,
            authorizationKind: .none,
            completion: completion
        )
    }

    @discardableResult
    func post<Object: Encodable, Response: Decodable>(
        _ object: Object,
        apiPath: String,
        parameters: [String: String?]?,
        reponseType: Response.Type,
        completion: @escaping ((Result<Response, NetworkServiceError>) -> Void)
    ) -> Cancellable? {
        post(
            object,
            apiPath: apiPath,
            parameters: parameters,
            headers: nil,
            authorizationKind: .none,
            reponseType: reponseType,
            completion: completion
        )
    }
}
