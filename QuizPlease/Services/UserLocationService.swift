//
//  UserLocationService.swift
//  QuizPlease
//
//  Created by Владислав on 20.04.2021.
//  Copyright © 2021 Владислав. All rights reserved.
//

import Foundation
import CoreLocation

class UserLocationService: NSObject {
    private override init() {}
    
    static let shared = UserLocationService()
    
    private let _locationManager = CLLocationManager()
    private var completion: ((CLLocation?) -> Void)?
    
    var isLocationAuthStatusDetermined = true
    var hasStartedUpdatingLocation = false

    // MARK: - Ask User Location
    ///Use this method to update user location.
    ///
    ///`completion` closure is executed after location is updated (either with success or failure). `completion` provides new location (if exists) and request status.
    func askUserLocation(completion: @escaping (CLLocation?) -> Void) {
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
            isLocationAuthStatusDetermined = false
            _locationManager.requestWhenInUseAuthorization()
        case .denied, .restricted:
            break
        default:
            break
        }
        
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest
        _locationManager.delegate = self
        self.completion = completion
        
        if isLocationAuthStatusDetermined {
            startUpdatingLocation()
        }
    }
    
    // MARK: - Start & Stop Updating Location
    private func startUpdatingLocation() {
        hasStartedUpdatingLocation = true
        _locationManager.startUpdatingLocation()
    }
    
    private func stopUpdatingLocation() {
        hasStartedUpdatingLocation = false
        _locationManager.stopUpdatingLocation()
    }
}

// MARK: - CLLocationManagerDelegate
extension UserLocationService: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        stopUpdatingLocation()
        completion?(locations.first)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        if hasStartedUpdatingLocation {
            completion?(nil)
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
        if isLocationAuthStatusDetermined {
            startUpdatingLocation()
        }
    }
}
