//
//  UserLocationService.swift
//  QuizPlease
//
//  Created by Владислав on 20.04.2021.
//  Copyright © 2021 Владислав. All rights reserved.
//

import CoreLocation

/// Object that can one-time provide the user's current geolocation
protocol UserLocationProvider {

    /// Requests 'When in use' authorization for tracking user location (if needed)
    /// and provides captured `CLLocation` instance in `completion` clousure
    func askUserLocation(completion: @escaping (CLLocation?) -> Void)
}

/// Service that requests for tracking uesr location
protocol UserLocationAuthorizationService {

    /// Requests 'When in use' authorization for tracking user location (if needed)
    /// and returns if any kind of geo authorization is provided
    func requestAuthorization(completion: @escaping (_ granted: Bool) -> Void)
}

final class UserLocationService: NSObject {

    static let shared = UserLocationService()

    private let locationManager: CLLocationManager

    private var authorizationHandler: ((Bool) -> Void)?
    private var locationHandler: ((CLLocation?) -> Void)?

    var isLocationAuthStatusDetermined = true
    var hasStartedUpdatingLocation = false

    private override init() {
        locationManager = CLLocationManager()
        super.init()

        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
    }

    private func requestAuthorizationIfNeeded() {
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
            isLocationAuthStatusDetermined = false
            locationManager.requestWhenInUseAuthorization()

        case .denied, .restricted:
            authorizationHandler?(false)

        case .authorizedAlways, .authorizedWhenInUse:
            authorizationHandler?(true)

        default:
            break
        }
    }

    // MARK: - Start & Stop Updating Location

    private func startUpdatingLocation() {
        hasStartedUpdatingLocation = true
        locationManager.startUpdatingLocation()
    }

    private func stopUpdatingLocation() {
        hasStartedUpdatingLocation = false
        locationManager.stopUpdatingLocation()
    }
}

// MARK: - CLLocationManagerDelegate

extension UserLocationService: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        stopUpdatingLocation()
        locationHandler?(locations.first)
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        if hasStartedUpdatingLocation {
            locationHandler?(nil)
        }
        stopUpdatingLocation()
    }

    @available(iOS 14.0, *)
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        handleAuthStatusChange(manager.authorizationStatus)
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        handleAuthStatusChange(status)
    }

    private func handleAuthStatusChange(_ status: CLAuthorizationStatus) {
        isLocationAuthStatusDetermined = status != .notDetermined
        let isAuthorized = status == .authorizedAlways || status == .authorizedWhenInUse
        authorizationHandler?(isAuthorized)
        if isLocationAuthStatusDetermined {
            startUpdatingLocation()
        }
    }
}

// MARK: - UserLocationProvider

extension UserLocationService: UserLocationProvider {

    /// Use this method to update user location.
    ///
    /// `completion` closure is executed after location is updated (either with success or failure).
    /// `completion` provides new location (if exists) and request status.
    func askUserLocation(completion: @escaping (CLLocation?) -> Void) {
        locationHandler = completion

        requestAuthorizationIfNeeded()

        if isLocationAuthStatusDetermined {
            startUpdatingLocation()
        }
    }
}

// MARK: - UserLocationAuthorizationService

extension UserLocationService: UserLocationAuthorizationService {

    func requestAuthorization(completion: @escaping (Bool) -> Void) {
        authorizationHandler = completion
        requestAuthorizationIfNeeded()
    }
}
