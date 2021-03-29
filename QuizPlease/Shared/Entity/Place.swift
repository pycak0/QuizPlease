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
    var longitude: Double = 0
    var latitude: Double = 0
    
    init(name: String, cityName: String, address: String) {
        self.title = name
        self.cityName = cityName
        self.shortAddress = address
//        self.longitude = longitude
//        self.latitude = latitude
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
}
