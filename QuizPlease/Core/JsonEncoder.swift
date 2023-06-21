//
//  JsonEncoder.swift
//  QuizPlease
//
//  Created by Владислав on 22.05.2023.
//  Copyright © 2023 Владислав. All rights reserved.
//

import Foundation

/// An object that encodes instances of a data type as JSON objects.
protocol JsonEncoder {

    /// Encodes the given top-level value and returns its JSON representation.
    ///
    /// - parameter value: The value to encode.
    /// - returns: A new `Data` value containing the encoded JSON data.
    /// - throws: `EncodingError.invalidValue` if a non-conforming floating-point value
    /// is encountered during encoding, and the encoding strategy is `.throw`.
    /// - throws: An error if any value throws an error during encoding.
    func encode<T>(_ value: T) throws -> Data where T: Encodable
}

extension JSONEncoder: JsonEncoder {}
