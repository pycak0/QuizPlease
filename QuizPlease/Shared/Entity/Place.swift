//
//  Place.swift
//  QuizPlease
//
//  Created by Владислав on 13.08.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import MapKit

class Place: NSObject, MKAnnotation, Decodable {
    var title: String?
    ///Place address with street only
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
    
    ///Place address with city and street
    var fullAddress: String {
        "\(cityName), \(shortAddress)"
    }
    
    var cityNameLatin: String {
        return cityName.applyingTransform(.toLatin, reverse: false) ?? cityName
    }
    
    ///Use this property instead of comparing '`coordinate.latitude == 0 && coordinate.longitude == 0`'
    var isZeroCoordinate: Bool {
        return coordinate.latitude == 0 && coordinate.longitude == 0
    }
}
