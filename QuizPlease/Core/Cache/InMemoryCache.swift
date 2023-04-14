//
//  InMemoryCache.swift
//  QuizPlease
//
//  Created by Владислав on 14.04.2023.
//  Copyright © 2023 Владислав. All rights reserved.
//

import Foundation

/// In-memory cache
class InMemoryCache<Key, Value>: Cache {

    private final class Wrapped {
        let value: Value

        init(_ value: Value) {
            self.value = value
        }
    }

    // MARK: - Private Properties

    private let cache: NSCache<NSString, Wrapped> = NSCache()

    // MARK: - Internal Properties

    /// Store the cache for the given amount of time (in minutes).
    /// - Important: Changing this value affects only the new elements.
    var timeout: Double = 5

    // MARK: - Lifecycle

    deinit {
        cache.removeAllObjects()
    }

    // MARK: - Private Methods

    private func nsString(_ key: Key) -> NSString {
        "\(key)" as NSString
    }

    // MARK: - Cache

    func set(_ value: Value, for key: Key) {
        cache.setObject(Wrapped(value), forKey: nsString(key))
        Timer.scheduledTimer(withTimeInterval: timeout * 60, repeats: false) { [weak self, key] _ in
            guard let self = self else { return }
            self.cache.removeObject(forKey: self.nsString(key))
        }
    }

    func get(key: Key) -> Value? {
        cache.object(forKey: nsString(key))?.value
    }

    func remove(key: Key) {
        cache.removeObject(forKey: nsString(key))
    }

    func removeAll() {
        cache.removeAllObjects()
    }
}
