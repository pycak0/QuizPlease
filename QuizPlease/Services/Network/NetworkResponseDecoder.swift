//
//  NetworkResponseDecoder.swift
//  QuizPlease
//
//  Created by Русаков Владислав Андреевич on 17.11.2025.
//  Copyright © 2025 Владислав. All rights reserved.
//

import Foundation

/// A type that decodes raw network response data into strongly-typed `Decodable` models.
///
/// Conformers to `NetworkResponseDecoder` are responsible for transforming binary `Data`
/// received from a network request into a concrete Swift type that conforms to `Decodable`.
/// The decoding outcome is represented as a `Result`, returning either the decoded object
/// on success or a `NetworkServiceError` on failure.
///
/// Typical implementations will use `JSONDecoder` (or a custom decoder) to parse JSON payloads,
/// but any decoding strategy can be used as long as it maps `Data` to a `Decodable` type.
///
/// - Note: This protocol abstracts decoding logic from networking code, enabling easier testing
///   and swapping of decoding strategies (e.g., custom date strategies, key decoding strategies).
///
/// - SeeAlso: `JSONDecoder`, `Decodable`, `NetworkServiceError`
protocol NetworkResponseDecoder {
    
    /// Decodes raw response data into a strongly-typed Decodable object.
    ///
    /// This method attempts to transform the provided binary `Data` into an instance of the
    /// specified `Decodable` type using the underlying decoder (e.g., `JSONDecoder`).
    /// It returns a `Result` to clearly distinguish between successful decoding and failure,
    /// surfacing decoding errors as `NetworkServiceError`.
    ///
    /// - Parameters:
    ///   - data: The raw response payload to decode.
    ///   - to: The concrete `Decodable` type to decode into.
    /// - Returns: A `Result` containing the decoded object on success, or a `.failure` with
    ///            a `NetworkServiceError.decoding` describing the underlying error on failure.
    /// - Important: Ensure that the expected model type matches the structure of the response
    ///              payload and that the decoder is configured with compatible strategies
    ///              (e.g., date decoding, key decoding).
    /// - SeeAlso: `Decodable`, `JSONDecoder`, `NetworkServiceError`
    func decode<Object: Decodable>(_ data: Data, to: Object.Type) -> Result<Object, NetworkServiceError>
}

final class NetworkResponseDecoderImpl: NetworkResponseDecoder {

    private let jsonDecoder: JsonDecoder

    init(jsonDecoder: JsonDecoder) {
        self.jsonDecoder = jsonDecoder
    }
    
    func decode<Object: Decodable>(_ data: Data, to: Object.Type) -> Result<Object, NetworkServiceError> {
        do {
            let object = try jsonDecoder.decode(Object.self, from: data)
            return .success(object)
        } catch {
            return .failure(.decoding(error))
        }
    }
}

