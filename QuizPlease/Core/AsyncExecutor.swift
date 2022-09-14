//
//  AsyncExecutor.swift
//  QuizPlease
//
//  Created by Владислав on 14.09.2022.
//  Copyright © 2022 Владислав. All rights reserved.
//

import Foundation

/// A service that executes tasks asynchronously
protocol AsyncExecutor {

    /// Executes block asynchronously
    /// - Parameter work: The block containing the work to perform.
    /// This block has no return value and no parameters.
    func async(execute work: @escaping () -> Void)
}

final class ConcurrentExecutorImpl: AsyncExecutor {

    func async(execute work: @escaping () -> Void) {
        DispatchQueue.global().async(execute: work)
    }
}
