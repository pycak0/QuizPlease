//
//  PlaceGeocoderTest.swift
//  QuizPleaseTests
//
//  Created by Владислав on 13.04.2023.
//  Copyright © 2023 Владислав. All rights reserved.
//

@testable import QuizPlease
import XCTest
import CoreLocation

final class PlaceGeocoderTest: XCTestCase {

    private var placeGeocoder: PlaceGeocoder!
    private var geocoderMock: GeocoderMock!

    override func setUp() {
        super.setUp()
        geocoderMock = GeocoderMock()
        placeGeocoder = PlaceGeocoder(geocoder: geocoderMock)
    }

    override func tearDown() {
        super.tearDown()
        placeGeocoder = nil
        geocoderMock = nil
    }

    func testPlaceGeocoderWithPlaceZeroCoordinate() {
        // Arrange
        let expectedCoordinate = CLLocationCoordinate2D(latitude: 1, longitude: 1)
        geocoderMock.coordinateMock = expectedCoordinate
        let place = Place.testWithZeroCoordinate

        // Act
        var actualCoordinate: CLLocationCoordinate2D?
        placeGeocoder.getCoordinate(place) { coordinate in
            actualCoordinate = coordinate
        }

        // Assert
        XCTAssert(geocoderMock.geocodeAddressCalled, "Geocoder should be used to find coordinates")
        XCTAssertEqual(actualCoordinate, expectedCoordinate, "Coordinate should be equal to expected")
        XCTAssertEqual(place, Place.testWithZeroCoordinate, "Place must not be modified inside the method")
    }

    func testPlaceGeocoderWithPlaceNonZeroCoordinate() {
        // Arrange
        let expectedCoordinate = CLLocationCoordinate2D(latitude: 1, longitude: 1)
        geocoderMock.coordinateMock = expectedCoordinate
        let place = Place.testWithUnitCoordinate

        // Act
        var actualCoordinate: CLLocationCoordinate2D?
        placeGeocoder.getCoordinate(place) { coordinate in
            actualCoordinate = coordinate
        }

        // Assert
        XCTAssertFalse(geocoderMock.geocodeAddressCalled, "Geocoder should not be used with non-zero coordinate")
        XCTAssertEqual(actualCoordinate, expectedCoordinate, "Coordinate should be equal to expected")
        XCTAssertEqual(place, Place.testWithUnitCoordinate, "Place must not be modified inside the method")
    }
}
