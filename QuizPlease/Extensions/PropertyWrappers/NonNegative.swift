//
//  NonNegative.swift
//  QuizPlease
//
//  Created by Владислав on 20.04.2023.
//  Copyright © 2023 Владислав. All rights reserved.
//

import Foundation

@propertyWrapper
struct NonNegative<Value: Numeric & Comparable> {
    var value: Value

    var wrappedValue: Value {
        get { value }

        set {
            if newValue < 0 {
                value = 0
            } else {
                value = newValue
            }
        }
    }

    init(wrappedValue: Value) {
        if wrappedValue < 0 {
            self.value = 0
        } else {
            self.value = wrappedValue
        }
    }
}
