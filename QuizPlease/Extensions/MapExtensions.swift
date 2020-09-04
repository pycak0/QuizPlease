//
//  MapExtensions.swift
//  QuizPlease
//
//  Created by Владислав on 24.08.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import MapKit

extension MKMapView {
    func centerToLocation(_ location: CLLocation, regionRadius: CLLocationDistance = 1000, animated: Bool = true) {
        let coordinateRegion = MKCoordinateRegion(
            center: location.coordinate,
            latitudinalMeters: regionRadius,
            longitudinalMeters: regionRadius)
        setRegion(coordinateRegion, animated: animated)
    }
    
    ///- parameter annotation: Optionally adds given annotation. If `nil`, no annotation is set. Default is `nil`
    func centerToAddress(_ address: String, addAnnotation annotation: MKAnnotation? = nil, regionRadius: CLLocationDistance = 1000, animated: Bool = true) {
        MapService.getCoordinates(from: address) { (location) in
            guard let location = location else { return }
            let coordinateRegion = MKCoordinateRegion(
                center: location,
                latitudinalMeters: regionRadius,
                longitudinalMeters: regionRadius)
            self.setRegion(coordinateRegion, animated: animated)
            if let place = annotation {
                self.addAnnotation(place)
            }
        }
        
    }
}
