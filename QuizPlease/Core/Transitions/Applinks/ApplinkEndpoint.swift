//
//  ApplinkEndpoint.swift
//  QuizPlease
//
//  Created by Владислав on 07.10.2022.
//  Copyright © 2022 Владислав. All rights reserved.
//

import UIKit

/// Object that show endpoints for its identifier
@objc
protocol ApplinkEndpoint {

    /// Identifier to define the endpoint
    static var identifier: String { get }

    /// Required initializer
    init()

    /// Show endpont with launch parameters
    /// - Parameters:
    ///   - parameters: launch parameters
    /// - Returns: `true`, if the endpoint was successfully shown.
    /// If any errors occured or could not show the endpoint, returns `false`
    func show(parameters: [String: String]) -> Bool
}
