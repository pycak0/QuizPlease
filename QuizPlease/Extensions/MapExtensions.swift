//
//  MapExtensions.swift
//  QuizPlease
//
//  Created by Владислав on 24.08.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import MapKit

extension MKMapView {
    ///Calls method `centerToLocation(with:regionRadius:animated:)` with `location`'s coordinate
    func centerToLocation(_ location: CLLocation, regionRadius: CLLocationDistance = 1000, animated: Bool = true) {
        centerToLocation(with: location.coordinate, regionRadius: regionRadius, animated: animated)
    }
    
    func centerToLocation(with coordinate: CLLocationCoordinate2D, regionRadius: CLLocationDistance = 1000, animated: Bool = true) {
        let coordinateRegion = MKCoordinateRegion(
            center: coordinate,
            latitudinalMeters: regionRadius,
            longitudinalMeters: regionRadius
        )
        setRegion(coordinateRegion, animated: animated)
    }
    
    ///- parameter annotation: Optionally adds given annotation. If `nil`, no annotation is set. Default is `nil`
    func centerToAddress(_ address: String, addAnnotation annotation: MKAnnotation? = nil, regionRadius: CLLocationDistance = 1000, animated: Bool = true) {
        MapService.getCoordinates(from: address) { (coordinate) in
            guard let coordinate = coordinate else { return }
            self.centerToLocation(with: coordinate, regionRadius: regionRadius, animated: animated)
            if let place = annotation {
                self.addAnnotation(place)
            }
        }
    }
}
