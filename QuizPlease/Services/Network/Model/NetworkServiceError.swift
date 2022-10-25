//
//  NetworkServiceError.swift
//  QuizPlease
//
//  Created by Владислав on 27.08.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import Foundation

enum NetworkServiceError: Error {
    case invalidUrl, jsonError, encodingError, invalidToken
    case serverError(_ statusCode: Int)
    case decoding(Error)
    case other(Error)

    var localizedDescription: String {
        switch self {
        case .invalidUrl:
            return "Request URL is invalid"
        case .jsonError:
            return "JSON Decoding Error"
        case .encodingError:
            return "Encoding Error"
        case .invalidToken:
            return "Unauthorized"
        case let .serverError(statusCode):
            return "Server Side Error. Status Code: \(statusCode)"
        case let .decoding(error), let .other(error):
            return error.localizedDescription
        }
    }
}
