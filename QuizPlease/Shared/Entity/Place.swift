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
    var address: String
    var longitude: Double
    var latitude: Double
    
    init(name: String, address: String, longitude: Double, latitude: Double) {
        self.title = name
        self.address = address
        self.longitude = longitude
        self.latitude = latitude
    }
}

extension Place {
    var location: CLLocation {
        CLLocation(latitude: latitude, longitude: longitude)
    }
    
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}
