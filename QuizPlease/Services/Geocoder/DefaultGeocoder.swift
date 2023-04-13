//
//  DefaultGeocoder.swift
//  QuizPlease
//
//  Created by Владислав on 13.04.2023.
//  Copyright © 2023 Владислав. All rights reserved.
//

import Foundation
import CoreLocation

/// A geocoder that uses Core Location's `CLGeocoder`
final class DefaultGeocoder: Geocoder {

    private let geocoder: CLGeocoder

    /// Initialize `DefaultGeocoder`
    /// - Parameter geocoder: `CLGeocoder` instance
    init(geocoder: CLGeocoder = .init()) {
        self.geocoder = geocoder
    }

    func geocodeAddress(_ address: String, completion: @escaping (CLLocationCoordinate2D?) -> Void) {
        geocoder.geocodeAddressString(address) { placemarks, error in
            if let error = error {
                print(error)
            }
            completion(placemarks?.first?.location?.coordinate)
        }
    }
}
