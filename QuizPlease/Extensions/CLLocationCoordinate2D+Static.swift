//
//  CLLocationCoordinate2D+Equatable.swift
//  QuizPlease
//
//  Created by Владислав on 13.04.2023.
//  Copyright © 2023 Владислав. All rights reserved.
//

import CoreLocation

extension CLLocationCoordinate2D {

    /// A convenience coordinate representing the origin at latitude 0 and longitude 0.
    /// - Note: This location is in the Gulf of Guinea, off the west coast of Africa, and is often used as a sentinel or default value.
    /// - Returns: A `CLLocationCoordinate2D` with `latitude` set to `0` and `longitude` set to `0`.
    public static var zero: CLLocationCoordinate2D { .init(latitude: 0, longitude: 0) }
}
