//
//  MapExtensions.swift
//  QuizPlease
//
//  Created by Владислав on 24.08.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import MapKit

public extension MKMapView {
    func centerToLocation(_ location: CLLocation, regionRadius: CLLocationDistance = 1000, animated: Bool = true) {
        let coordinateRegion = MKCoordinateRegion(
            center: location.coordinate,
            latitudinalMeters: regionRadius,
            longitudinalMeters: regionRadius)
        setRegion(coordinateRegion, animated: animated)
    }
    
    func centerToAddress(_ address: String, regionRadius: CLLocationDistance = 1000, animated: Bool = true) {
        MapService.getCoordinates(from: address) { (location) in
            guard let location = location else { return }
            let coordinateRegion = MKCoordinateRegion(
                center: location,
                latitudinalMeters: regionRadius,
                longitudinalMeters: regionRadius)
            self.setRegion(coordinateRegion, animated: animated)
        }
        
    }
}
