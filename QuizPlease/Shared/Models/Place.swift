//
//  Place.swift
//  QuizPlease
//
//  Created by Владислав on 13.08.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import MapKit

enum PlaceConstants {
    /// In meters
    static let deviationLimit: Double = 300
}

class Place: NSObject, MKAnnotation, Decodable {
    var title: String?
    /// Place address with street only
    var shortAddress: String
    var cityName: String
    private var longitude: Double
    private var latitude: Double

    init(name: String, cityName: String, address: String, latitude: Double = 0, longitude: Double = 0) {
        self.title = name
        self.cityName = cityName
        self.shortAddress = address
        self.longitude = longitude
        self.latitude = latitude
    }

    lazy var coordinate: CLLocationCoordinate2D = {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }()

    private var location: CLLocation {
        CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
    }

    /// Place address with city and street
    var fullAddress: String {
        "\(cityName), \(shortAddress)"
    }

    var cityNameLatin: String {
        return cityName.applyingTransform(.toLatin, reverse: false) ?? cityName
    }

    /// Use this property instead of comparing '`coordinate.latitude == 0 && coordinate.longitude == 0`'
    var isZeroCoordinate: Bool {
        return coordinate.latitude == 0 && coordinate.longitude == 0
    }

    /// Returns `true` if given `location` does not exceed the limit of deviation from `self` coordinate.
    ///
    /// The deviation limit is specified in '`PlaceConstants`'
    func isCloseToLocation(_ location: CLLocation) -> Bool {
        return location.distance(from: self.location) <= PlaceConstants.deviationLimit
    }

    // MARK: - Overrides

    override var hash: Int {
        var hasher = Hasher()
        hasher.combine(title)
        hasher.combine(shortAddress)
        hasher.combine(cityName)
        hasher.combine(longitude)
        hasher.combine(latitude)
        return hasher.finalize()
    }

    override func isEqual(_ object: Any?) -> Bool {
        guard let object = object as? Place else { return false }
        return title == object.title
            && shortAddress == object.shortAddress
            && cityName == object.cityName
            && coordinate == object.coordinate
    }
}
