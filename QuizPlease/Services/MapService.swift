//
//  MapService.swift
//  MetroStationsInfo
//
//  Created by Владислав on 12.08.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import Foundation
import MapKit

final class MapService {
    // singleton
    private init() {}

    // MARK: - Get Coordinates

    @available(*, deprecated, message: "Use Geocoder class instead")
    static func getCoordinates(from address: String, completion: @escaping (CLLocationCoordinate2D?) -> Void) {
        getLocation(from: address) { (location) in
            completion(location?.coordinate)
        }
    }

    @available(*, deprecated, message: "Use Geocoder class instead")
    static func getLocation(from address: String, completion: @escaping (CLLocation?) -> Void) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address) { placemarks, error in
            if let error = error {
                print("[\(Self.self) error]. Tried to geocode address: '\(address)', but got error: \(error)")
                completion(nil)
                return
            }
            completion(placemarks?.first?.location)
        }
    }
}
