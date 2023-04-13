//
//  GeocoderMock.swift
//  QuizPleaseTests
//
//  Created by Владислав on 13.04.2023.
//  Copyright © 2023 Владислав. All rights reserved.
//

@testable import QuizPlease
import Foundation
import CoreLocation

final class GeocoderMock: Geocoder {

    var geocodeAddressCalled = false
    var coordinateMock: CLLocationCoordinate2D?

    func geocodeAddress(_ address: String, completion: @escaping (CLLocationCoordinate2D?) -> Void) {
        geocodeAddressCalled = true
        completion(coordinateMock)
    }
}
