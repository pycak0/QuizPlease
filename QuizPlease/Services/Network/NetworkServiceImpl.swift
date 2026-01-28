//
//  NetworkServiceImpl.swift
//  QuizPlease
//
//  Created by Русаков Владислав Андреевич on 17.11.2025.
//  Copyright © 2025 Владислав. All rights reserved.
//

import Foundation
import Alamofire

final class NetworkServiceImpl: NetworkServiceProtocol {

    private let responseDecoder: NetworkResponseDecoder
    private let defaults: DefaultsManager
    private let log: Logger

    // MARK: - Init

    init(
        responseDecoder: NetworkResponseDecoder,
        defaults: DefaultsManager,
        log: Logger
    ) {
        self.responseDecoder = responseDecoder
        self.defaults = defaults
        self.log = log
    }

    private func baseUrlComponents(networkConfiguration: NetworkConfiguration) -> URLComponents {
        var urlComps = URLComponents(string: networkConfiguration.host)!
        urlComps.queryItems = nil
        return urlComps
    }

    // MARK: - GET

    @discardableResult
    func get<T: Decodable & Sendable>(
        _ responseType: T.Type,
        apiPath: String,
        parameters: [String : String?]?,
        headers: [String : String]?,
        authorizationKind: NetworkService.AuthorizationKind,
        networkConfiguration: NetworkConfiguration = NetworkConfiguration.standard,
        completion: @escaping (Result<T, NetworkServiceError>) -> Void
    ) -> Cancellable? {
        var urlComponents = baseUrlComponents(networkConfiguration: networkConfiguration)
        urlComponents.path = apiPath
        urlComponents.queryItems = parameters?.map { URLQueryItem(name: $0, value: $1) }

        guard let url = urlComponents.url else {
            completion(.failure(.invalidUrl))
            return nil
        }
        var request = URLRequest(url: url)
        for (key, value) in headers ?? [:] {
            request.setValue(value, forHTTPHeaderField: key)
        }

        let auth: (key: String, value: String)?
        switch authorizationKind {
        case .none:
            auth = nil
        case .bearer:
            if let token = defaults.getUserAuthInfo()?.accessToken {
                auth = createBearerAuthHeader(with: token)
            } else {
                completion(.failure(.invalidToken))
                return nil
            }
        case let .bearerCustom(token):
            auth = createBearerAuthHeader(with: token)
        }

        if let auth {
            request.setValue(auth.value, forHTTPHeaderField: auth.key)
        }

        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 15

        log.info("""
        REQUEST ⬆️ \(request.httpMethod ?? "GET") \(url)
        Headers:
        \(NetworkLogFormatter.prettyHeaders(request.allHTTPHeaderFields ?? [:]))
        Body:
        \(NetworkLogFormatter.prettyBody(request.httpBody))
        """)

        let session = URLSession(configuration: config)
        let task = session.dataTask(with: request) { [weak self] (data, response, error) in
            guard let self else { return }

            if let error = error {
                log.error("❌ Error occured when executing GET request: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    completion(.failure(.networkError(error as NSError)))
                }
                return
            }

            guard let response = response as? HTTPURLResponse else {
                log.error("🚫 Received Non-HTTP Response")
                DispatchQueue.main.async {
                    completion(.failure(.serverError(500)))
                }
                return
            }

            log.info("""
            RESPONSE ⬇️ \(request.httpMethod ?? "GET") \(url)
            Status Code: \(NetworkLogFormatter.httpStatus(code: response.statusCode))
            Headers:
            \(NetworkLogFormatter.prettyHeaders(response.allHeaderFields))
            Body:
            \(NetworkLogFormatter.prettyBody(data))
            """)

            guard response.statusCode == 200, let data = data else {
                log.error("❌ Either status code != 200, or data is nil")
                DispatchQueue.main.async {
                    completion(.failure(.serverError(response.statusCode)))
                }
                return
            }

            let result = self.responseDecoder.decode(data, to: responseType)
            DispatchQueue.main.async {
                completion(result)
            }
        }
        task.resume()

        return task
    }

    // MARK: - POST (JSON)

    @discardableResult
    func post<Object: Encodable, Response: Decodable & Sendable>(
        _ object: Object,
        apiPath: String,
        parameters: [String : String?]?,
        headers: [String : String]?,
        authorizationKind: NetworkService.AuthorizationKind,
        reponseType: Response.Type,
        completion: @escaping (Result<Response, NetworkServiceError>) -> Void
    ) -> Cancellable? {
        var urlComponents = baseUrlComponents(networkConfiguration: .standard)
        urlComponents.path = apiPath
        urlComponents.queryItems = parameters?.map { URLQueryItem(name: $0, value: $1) }

        guard let url = urlComponents.url else {
            completion(.failure(.invalidUrl))
            return nil
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        for (key, value) in headers ?? [:] {
            request.setValue(value, forHTTPHeaderField: key)
        }

        let auth: (key: String, value: String)?
        switch authorizationKind {
        case .none:
            auth = nil
        case .bearer:
            if let token = defaults.getUserAuthInfo()?.accessToken {
                auth = createBearerAuthHeader(with: token)
            } else {
                completion(.failure(.invalidToken))
                return nil
            }
        case let .bearerCustom(token):
            auth = createBearerAuthHeader(with: token)
        }

        if let auth {
            request.setValue(auth.value, forHTTPHeaderField: auth.key)
        }

        do {
            let jsonData = try JSONEncoder().encode(object)
            request.httpBody = jsonData
        } catch {
            completion(.failure(.encodingError))
            return nil
        }

        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 15

        log.info("""
        REQUEST ⬆️ \(request.httpMethod ?? "POST") \(url)
        Headers:
        \(NetworkLogFormatter.prettyHeaders(request.allHTTPHeaderFields ?? [:]))
        Body:
        \(NetworkLogFormatter.prettyBody(request.httpBody))
        """)

        let session = URLSession(configuration: config)
        let task = session.dataTask(with: request) { [weak self] data, response, error in
            guard let self else { return }

            if let error = error {
                log.error("❌ Error occured when executing POST request: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    completion(.failure(.other(error)))
                }
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                log.error("🚫 Received Non-HTTP Response")
                DispatchQueue.main.async {
                    completion(.failure(.serverError(500)))
                }
                return
            }

            log.info("""
            RESPONSE ⬇️ \(request.httpMethod ?? "POST") \(httpResponse.url?.absoluteString ?? "unknown")
            Status Code: \(NetworkLogFormatter.httpStatus(code: httpResponse.statusCode))
            Headers:
            \(NetworkLogFormatter.prettyHeaders(httpResponse.allHeaderFields))
            Body:
            \(NetworkLogFormatter.prettyBody(data))
            """)

            guard httpResponse.statusCode == 200, let data = data else {
                log.error("❌ Either status code != 200, or data is nil")
                DispatchQueue.main.async {
                    completion(.failure(.serverError(httpResponse.statusCode)))
                }
                return
            }

            let result = self.responseDecoder.decode(data, to: reponseType)
            DispatchQueue.main.async {
                completion(result)
            }
        }
        task.resume()

        return task
    }

    // MARK: - AF POST (multipart/form-data)

    func afPost<Response: Decodable & Sendable>(
        with multipartFormDataObjects: MultipartFormDataObjects,
        queryParameters: [String: String?]?,
        and headers: [String : String]?,
        to apiPath: String,
        responseType: Response.Type,
        authorizationKind: NetworkService.AuthorizationKind,
        completion: @escaping (Result<Response, NetworkServiceError>) -> Void
    ) {
        var urlComponents = baseUrlComponents(networkConfiguration: .standard)
        urlComponents.path = apiPath
        urlComponents.queryItems = queryParameters?.map { URLQueryItem(name: $0, value: $1) }

        var headers = headers ?? [:]

        let auth: (key: String, value: String)?
        switch authorizationKind {
        case .none:
            auth = nil
        case .bearer:
            if let token = defaults.getUserAuthInfo()?.accessToken {
                auth = createBearerAuthHeader(with: token)
            } else {
                completion(.failure(.invalidToken))
                return
            }
        case let .bearerCustom(token):
            auth = createBearerAuthHeader(with: token)
        }

        if let auth {
            headers[auth.key] = auth.value
        }


        let httpHeaders = headers.isEmpty ? nil : HTTPHeaders(headers)
        let httpMethod = "POST"
        let formDataMessage = "(Content-Disposition: form-data)"

        log.info("""
        REQUEST ⬆️ \(httpMethod) \(urlComponents.url?.absoluteString ?? "unknown") \(formDataMessage)
        Headers:
        \(NetworkLogFormatter.prettyHeaders(headers))
        Body:
        \(multipartFormDataObjects)
        """)

        AF.upload(
            multipartFormData: { (multipartFormData) in
                for object in multipartFormDataObjects {
                    multipartFormData.append(
                        object.data,
                        withName: object.name,
                        fileName: object.fileName,
                        mimeType: object.mimeType
                    )
                }
            },
            to: urlComponents,
            headers: httpHeaders
        ).responseData(queue: .global()) { [weak self] (afResponse) in
            guard let self else { return }

            let statusCode = afResponse.response?.statusCode ?? -1
            let responseHeaders = afResponse.response?.allHeaderFields ?? [:]

            log.info("""
            RESPONSE ⬇️ \(afResponse.request?.httpMethod ?? httpMethod) \(afResponse.response?.url?.absoluteString ?? "unknown") \(formDataMessage)
            Status Code: \(NetworkLogFormatter.httpStatus(code: statusCode))
            Headers:
            \(NetworkLogFormatter.prettyHeaders(responseHeaders))
            Body:
            \(NetworkLogFormatter.prettyBody(afResponse.data))
            """)

            switch afResponse.result {
            case let .failure(error):
                log.error("❌ AF.upload failure: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    completion(.failure(.other(error)))
                }
            case let .success(data):
                let result = self.responseDecoder.decode(data, to: responseType)
                DispatchQueue.main.async {
                    completion(result)
                }
            }
        }
    }

    // MARK: - AF POST (x-www-form-urlencoded via multipart builder)

    func afPost<Response: Decodable & Sendable>(
        with bodyParameters: [String : String?],
        queryParameters: [String : String?]?,
        and headers: [String : String]?,
        to apiPath: String,
        responseType: Response.Type,
        authorizationKind: NetworkService.AuthorizationKind,
        completion: @escaping (Result<Response, NetworkServiceError>) -> Void
    ) {
        afPost(
            with: MultipartFormDataObjects(bodyParameters),
            queryParameters: queryParameters,
            and: headers,
            to: apiPath,
            responseType: responseType,
            authorizationKind: authorizationKind,
            completion: completion
        )
    }

    private func createBearerAuthHeader(
        with userToken: String
    ) -> (key: String, value: String) {
        return ("Authorization", "Bearer \(userToken)")
    }
}
