//
//  ServiceAssembly.swift
//  QuizPlease
//
//  Created by Владислав on 22.12.2022.
//  Copyright © 2022 Владислав. All rights reserved.
//

import Foundation

/// Service layer assembly
final class ServiceAssembly {

    static let shared = ServiceAssembly(core: .shared)

    private let core: CoreAssembly

    /// Initialize with core services
    /// - Parameter core: Object that assembles Core tools of the App
    init(core: CoreAssembly) {
        self.core = core
    }

    /// Service that sends analytic events
    lazy var analytics: AnalyticsService = AnalyticsServiceImpl()
}
