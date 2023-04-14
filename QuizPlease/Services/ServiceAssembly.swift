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

    /// Service assembly shared instance
    static let shared = ServiceAssembly(core: .shared)

    /// Object that assembles Core tools of the App
    let core: CoreAssembly

    /// Initialize with core services
    /// - Parameter core: Object that assembles Core tools of the App
    init(core: CoreAssembly) {
        self.core = core
    }

    /// Service that sends analytic events
    lazy var analytics: AnalyticsService = AnalyticsServiceImpl()

    /// A geocoder that uses Core Location’s CLGeocoder
    lazy var defaultGeocoder: Geocoder = DefaultGeocoder()

    /// Service that provides `Place` coordinates
    lazy var placeGeocoder: PlaceGeocoderProtocol = {
        PlaceGeocoder(geocoder: defaultGeocoder)
    }()

    /// Object that can one-time provide the user’s current geolocation
    lazy var userLocationProvider: UserLocationProvider = UserLocationService.shared

    /// Service that requests for tracking uesr location
    lazy var userLocationAuthorizationService: UserLocationAuthorizationService
        = UserLocationService.shared

    /// Service that loads Game info
    lazy var gameInfoLoader: GameInfoLoader = {
        GameInfoLoaderImpl(networkService: NetworkService.shared)
    }()
}
