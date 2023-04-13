//
//  CLLocationCoordinate2D+Equatable.swift
//  QuizPlease
//
//  Created by Владислав on 13.04.2023.
//  Copyright © 2023 Владислав. All rights reserved.
//

import CoreLocation

extension CLLocationCoordinate2D: Equatable {
    public static func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        return abs(lhs.longitude - rhs.longitude) <= .ulpOfOne
            && abs(lhs.latitude - rhs.latitude) <= .ulpOfOne
    }
}
