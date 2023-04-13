//
//  Geocoder.swift
//  QuizPlease
//
//  Created by Владислав on 13.04.2023.
//  Copyright © 2023 Владислав. All rights reserved.
//

import Foundation
import struct CoreLocation.CLLocationCoordinate2D

/// Object that geocodes address string to coordinates
protocol Geocoder {

    /// Geocode given address string to coordinates on map in form of '`CLLocationCoordinate2D`'
    func geocodeAddress(_ address: String, completion: @escaping (CLLocationCoordinate2D?) -> Void)
}
