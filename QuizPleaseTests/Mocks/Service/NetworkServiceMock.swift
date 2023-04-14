//
//  NetworkServiceMock.swift
//  QuizPleaseTests
//
//  Created by Владислав on 14.04.2023.
//  Copyright © 2023 Владислав. All rights reserved.
//

@testable import QuizPlease

final class NetworkServiceMock<Response: Decodable>: NetworkServiceProtocol {

    var getCalled = false

    var cancellableMock: Cancellable?
    var resultMock: Result<Response, NetworkServiceError> = .failure(.invalidToken)

    // swiftlint:disable function_parameter_count force_cast
    func get<T>(
        _ type: T.Type,
        apiPath: String,
        parameters: [String: String?],
        headers: [String: String]?,
        authorizationKind: NetworkService.AuthorizationKind,
        completion: @escaping ((Result<T, NetworkServiceError>) -> Void)
    ) -> Cancellable? where T: Decodable {
        getCalled = true
        switch resultMock {
        case .success(let success):
            completion(.success(success as! T))
        case .failure(let failure):
            completion(.failure(failure))
        }
        return cancellableMock
    }
    // swiftlint:enable function_parameter_count force_cast
}
