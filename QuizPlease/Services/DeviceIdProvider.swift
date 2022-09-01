//
//  DeviceIdProvider.swift
//  QuizPlease
//
//  Created by Владислав on 01.09.2022.
//  Copyright © 2022 Владислав. All rights reserved.
//

import Foundation

/// Device unique identifier provider
protocol DeviceIdProvider {

    /// Get device identifier
    /// - Returns: Device unique identifier
    func get() -> String?
}

/// Device unique identifier provider implementation
final class DeviceIdProviderImpl: DeviceIdProvider {

    private let defaultsManager: DefaultsManager = .shared

    func get() -> String? {
        defaultsManager.getFcmToken()
    }
}
