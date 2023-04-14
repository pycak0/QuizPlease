//
//  InMemoryCacheMock.swift
//  QuizPleaseTests
//
//  Created by Владислав on 14.04.2023.
//  Copyright © 2023 Владислав. All rights reserved.
//

@testable import QuizPlease

final class InMemoryCacheMock<Key, Value>: InMemoryCache<Key, Value> {

    var getCalled = false
    var setCalled = false
    var removeCalled = false
    var removeAllCalled = false

    var getMock: Value?

    override func set(_ value: Value, for key: Key) {
        setCalled = true
    }

    override func get(key: Key) -> Value? {
        getCalled = true
        return getMock
    }

    override func remove(key: Key) {
        removeCalled = true
    }

    override func removeAll() {
        removeAllCalled = true
    }
}
