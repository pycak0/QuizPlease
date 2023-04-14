//
//  Cache.swift
//  QuizPlease
//
//  Created by Владислав on 14.04.2023.
//  Copyright © 2023 Владислав. All rights reserved.
//

import Foundation

/// Cache service protocol
protocol Cache {

    associatedtype Value
    associatedtype Key

    /// Save value to cache with specified key
    func set(_ value: Value, for key: Key)

    /// Retrieve value from cache by key
    func get(key: Key) -> Value?

    /// Remove value from cache by key
    func remove(key: Key)

    /// Clear the cache
    func removeAll()
}
