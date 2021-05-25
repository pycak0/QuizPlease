//
//  Cancellable.swift
//  QuizPlease
//
//  Created by Владислав on 25.05.2021.
//  Copyright © 2021 Владислав. All rights reserved.
//

import Foundation

public protocol Cancellable {
    func cancel()
}

extension URLSessionTask: Cancellable {}
