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
    var longitude: Double = 0
    var latitude: Double = 0
    
    init(name: String, address: String) {
        self.title = name
        self.address = address
//        self.longitude = longitude
//        self.latitude = latitude
    }
    
    lazy var coordinate: CLLocationCoordinate2D = {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }()
}
