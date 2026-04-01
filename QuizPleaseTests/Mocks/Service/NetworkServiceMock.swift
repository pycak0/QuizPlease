//
//  NetworkServiceMock.swift
//  QuizPleaseTests
//
//  Created by Владислав on 14.04.2023.
//  Copyright © 2023 Владислав. All rights reserved.
//

@testable import QuizPlease

final class NetworkServiceMock<MockResponse: Decodable>: NetworkServiceProtocol {

    var getCalled = false
    var postCalled = false

    var cancellableMock: Cancellable?
    var resultMock: Result<MockResponse, NetworkServiceError> = .failure(.invalidToken)

    private func complete<Response>(
        with completion: @escaping (Result<Response, NetworkServiceError>) -> Void
    ) where Response: Decodable {
        switch resultMock {
        case .success(let success):
            guard let response = success as? Response else {
                fatalError("Unexpected mocked response type: \(type(of: success))")
            }
            completion(.success(response))
        case .failure(let failure):
            completion(.failure(failure))
        }
    }

    // swiftlint:disable function_parameter_count
    func get<T>(
        _ type: T.Type,
        apiPath: String,
        parameters: [String: String?]?,
        headers: [String: String]?,
        authorizationKind: NetworkService.AuthorizationKind,
        networkConfiguration: NetworkConfiguration,
        completion: @escaping ((Result<T, NetworkServiceError>) -> Void)
    ) -> Cancellable? where T: Decodable {
        getCalled = true
        complete(with: completion)
        return cancellableMock
    }

    func afPost<Response>(
        with bodyParameters: [String: String?],
        queryParameters: [String: String?]?,
        and headers: [String: String]?,
        to apiPath: String,
        responseType: Response.Type,
        authorizationKind: NetworkService.AuthorizationKind,
        completion: @escaping (Result<Response, NetworkServiceError>) -> Void
    ) where Response: Decodable {
        postCalled = true
        complete(with: completion)
    }

    func afPost<Response>(
        with multipartFormDataObjects: MultipartFormDataObjects,
        queryParameters: [String: String?]?,
        and headers: [String: String]?,
        to apiPath: String,
        responseType: Response.Type,
        authorizationKind: NetworkService.AuthorizationKind,
        completion: @escaping (Result<Response, NetworkServiceError>) -> Void
    ) where Response: Decodable {
        postCalled = true
        complete(with: completion)
    }

    func post<Object, Response>(
        _ object: Object,
        apiPath: String,
        parameters: [String: String?]?,
        headers: [String: String]?,
        authorizationKind: NetworkService.AuthorizationKind,
        reponseType: Response.Type,
        completion: @escaping ((Result<Response, NetworkServiceError>) -> Void)
    ) -> Cancellable? where Object: Encodable, Response: Decodable {
        postCalled = true
        complete(with: completion)
        return cancellableMock
    }
    // swiftlint:enable function_parameter_count
}
