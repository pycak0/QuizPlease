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

    // MARK: - Init

    init(responseDecoder: NetworkResponseDecoder = NetworkResponseDecoderImpl()) {
        self.responseDecoder = responseDecoder
    }

    private var baseUrlComponents: URLComponents {
        var urlComps = URLComponents(string: NetworkConfiguration.standard.host)!
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
        completion: @escaping (Result<T, NetworkServiceError>) -> Void
    ) -> Cancellable? {
        var urlComponents = baseUrlComponents
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
        if let auth = authorizationKind.header {
            request.setValue(auth.value, forHTTPHeaderField: auth.key)
        } else if authorizationKind != .none {
            completion(.failure(.invalidToken))
            return nil
        }
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 15

        print("""
        \n=====
        [\(Self.self).swift] REQUEST ⬆️
        URL: \(url)
        HTTP Method: \(request.httpMethod ?? "GET")
        Headers: \(request.allHTTPHeaderFields ?? [:])
        =====\n\n
        """)

        let session = URLSession(configuration: config)
        let task = session.dataTask(with: request) { [weak self] (data, response, error) in
            guard let self else { return }

            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(.other(error)))
                }
                return
            }

            guard let response = response as? HTTPURLResponse else {
                print("""
                🚫 Error: Received Non-HTTP Response
                =====\n\n
                """)
                DispatchQueue.main.async {
                    completion(.failure(.serverError(500)))
                }
                return
            }

            print("""
            \n=====
            [\(Self.self).swift] RESPONSE ⬇️
            URL: \(url)
            Status Code: \(response.statusCode)
            """)
            guard response.statusCode == 200, let data = data else {
                print("""
                ❌ Error: either status code != 200, or data is nil
                =====\n\n
                """)
                DispatchQueue.main.async {
                    completion(.failure(.serverError(response.statusCode)))
                }
                return
            }

            print("""
            Body:
            \(String(data: data, encoding: .utf8) ?? "❌ JSON error.")
            =====\n\n
            """)
            let result = self.responseDecoder.decode(data, to: responseType)
            DispatchQueue.main.async {
                completion(result)
            }
        }
        task.resume()

        return task
    }

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
        var urlComponents = baseUrlComponents
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

        if let auth = authorizationKind.header {
            request.setValue(auth.value, forHTTPHeaderField: auth.key)
        } else if authorizationKind != .none {
            completion(.failure(.invalidToken))
            return nil
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

        print("""
        \n=====
        [\(Self.self).swift] REQUEST ⬆️
        URL: \(url)
        HTTP Method: POST
        Headers: \(request.allHTTPHeaderFields ?? [:])
        Body: \(String(data: request.httpBody ?? Data(), encoding: .utf8) ?? "nil")
        =====\n\n
        """)

        let session = URLSession(configuration: config)
        let task = session.dataTask(with: request) { [weak self] data, response, error in
            guard let self else { return }

            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(.other(error)))
                }
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                print("""
                🚫 Error: Received Non-HTTP Response
                =====\n\n
                """)
                DispatchQueue.main.async {
                    completion(.failure(.serverError(500)))
                }
                return
            }

            print("""
            \n=====
            [\(Self.self).swift] RESPONSE ⬇️
            URL: \(httpResponse.url?.absoluteString ?? "unknown")
            Status Code: \(httpResponse.statusCode)
            """)

            guard httpResponse.statusCode == 200, let data = data else {
                print("""
                ❌ Error: either status code != 200, or data is nil
                =====\n\n
                """)
                DispatchQueue.main.async {
                    completion(.failure(.serverError(httpResponse.statusCode)))
                }
                return
            }

            print("""
            Body:
            \(String(data: data, encoding: .utf8) ?? "❌ JSON error.")
            =====\n\n
            """)
            let result = self.responseDecoder.decode(data, to: reponseType)
            DispatchQueue.main.async {
                completion(result)
            }
        }
        task.resume()

        return task
    }

    func afPost<Response: Decodable & Sendable>(
        with multipartFormDataObjects: MultipartFormDataObjects,
        queryParameters: [String: String?]?,
        and headers: [String : String]?,
        to apiPath: String,
        responseType: Response.Type,
        authorizationKind: NetworkService.AuthorizationKind,
        completion: @escaping (Result<Response, NetworkServiceError>) -> Void
    ) {
        var urlComponents = baseUrlComponents
        urlComponents.path = apiPath
        urlComponents.queryItems = queryParameters?.map { URLQueryItem(name: $0, value: $1) }

        var headers = headers ?? [:]
        if let auth = authorizationKind.header {
            headers[auth.key] = auth.value
        } else if authorizationKind != .none {
            completion(.failure(.invalidToken))
            return
        }
        let httpHeaders = headers.isEmpty ? nil : HTTPHeaders(headers)
        let formDataMessage = "(Content-Disposition: form-data)"
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

            let statusCode = afResponse.response?.statusCode.description ?? "unknown"
            print("""
            \n=====
            [\(Self.self).swift] RESPONSE ⬇️
            URL: \(afResponse.response?.url?.description ?? "unknown")
            HTTP Method: \(afResponse.request?.httpMethod ?? "POST") \(formDataMessage)
            Status Code: \(statusCode)
            """)
            switch afResponse.result {
            case let .failure(error):
                print("Error: \(error)")
                DispatchQueue.main.async {
                    completion(.failure(.other(error)))
                }
            case let .success(data):
                print("Body:")
                print(String(data: data, encoding: .utf8) ?? "json decoding error")
                let result = self.responseDecoder.decode(data, to: responseType)
                DispatchQueue.main.async {
                    completion(result)
                }
            }
            print("=====\n\n")
        }
        print("""
        \n=====
        [\(Self.self).swift] REQUEST ⬆️
        URL: \(urlComponents.url?.description ?? "unknown")
        HTTP Method: POST \(formDataMessage)
        Headers: \(headers)
        Body parameters: \(multipartFormDataObjects)
        =====\n\n
        """)
    }

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
}

