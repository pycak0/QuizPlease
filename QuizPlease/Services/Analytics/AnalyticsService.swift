//
//  AnalyticsService.swift
//  QuizPlease
//
//  Created by Владислав on 22.12.2022.
//  Copyright © 2022 Владислав. All rights reserved.
//

import Foundation
import FirebaseAnalytics

/// Service that sends analytic events
protocol AnalyticsService {

    /// Send event to analytical system
    /// - Parameter event: `AnalyticsEvent` instance
    func sendEvent(_ event: AnalyticsEvent)
}

/// Class that implements service that sends analytic events to Firebase
final class AnalyticsServiceImpl: AnalyticsService {

    func sendEvent(_ event: AnalyticsEvent) {
        Analytics.logEvent(event.name, parameters: event.parameters)
    }
}
