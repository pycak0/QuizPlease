//
//  Place.swift
//  QuizPleaseTests
//
//  Created by Владислав on 13.04.2023.
//  Copyright © 2023 Владислав. All rights reserved.
//

@testable import QuizPlease
import Foundation

extension Place {

    class var testWithZeroCoordinate: Place {
        test.build()
    }

    class var testWithUnitCoordinate: Place {
        test.longitude(1).latitude(1).build()
    }

    class var test: Builder {
        Builder()
    }

    final class Builder {
        private var place = Place(name: "Place", cityName: "City", address: "Address", latitude: 0, longitude: 0)

        func title(_ title: String) -> Builder {
            place.title = title
            return self
        }

        func cityName(_ cityName: String) -> Builder {
            place.cityName = cityName
            return self
        }

        func shortAddress(_ address: String) -> Builder {
            place.shortAddress = address
            return self
        }

        func latitude(_ latitude: Double) -> Builder {
            place.coordinate.latitude = latitude
            return self
        }

        func longitude(_ longitude: Double) -> Builder {
            place.coordinate.longitude = longitude
            return self
        }

        func build() -> Place {
            return place
        }
    }
}
