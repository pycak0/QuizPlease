//
//  URLQueryItem+optional.swift
//  QuizPlease
//
//  Created by Владислав on 13.09.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import Foundation

extension URLQueryItem {
    ///Optional initializator. If `nullableValue` is `nil`, initializes `nil`. Convenient for filtering non-nil query items then.
    init?(name: String, nullableValue: String?) {
        guard nullableValue != nil else { return nil }
        self.init(name: name, value: nullableValue)
    }
}
