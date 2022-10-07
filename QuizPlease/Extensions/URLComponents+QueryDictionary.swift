//
//  URLComponents+QueryDictionary.swift
//  QuizPlease
//
//  Created by Владислав on 09.10.2022.
//  Copyright © 2022 Владислав. All rights reserved.
//

import Foundation

extension URLComponents {

    /// Represents `queryItems` in the form of the dictionary.
    var queryDictionary: [String: String?]? {
        queryItems?.reduce(into: [:]) { $0[$1.name] = $1.value }
    }
}
