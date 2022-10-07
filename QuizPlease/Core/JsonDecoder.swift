//
//  JsonDecoder.swift
//  QuizPlease
//
//  Created by Владислав on 14.09.2022.
//  Copyright © 2022 Владислав. All rights reserved.
//

import Foundation

/// An object that decodes instances of a data type from JSON objects.
protocol JsonDecoder {

    /// Decode `Data` into the provided type.
    ///
    /// - Parameters:
    ///   - type:  The `Type` to be decoded.
    ///   - data:  The `Data` to be decoded.
    ///
    /// - Returns: The decoded value of type `T`.
    /// - Throws:  Any error that occurs during decode.
    func decode<T>(_ type: T.Type, from data: Data) throws -> T where T: Decodable
}

extension JSONDecoder: JsonDecoder {}
