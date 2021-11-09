//
//  MKMapView+Extensions.swift
//  QuizPlease
//
//  Created by Владислав on 24.08.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import MapKit

extension MKMapView {
    
    /// Calls method `setCenter(_:regionRadius:animated:)` with `location`'s coordinate
    func setCenter(
        _ location: CLLocation,
        regionRadius: CLLocationDistance = 1000,
        animated: Bool = true
    ) {
        setCenter(location.coordinate, regionRadius: regionRadius, animated: animated)
    }
    
    func setCenter(
        _ coordinate: CLLocationCoordinate2D,
        regionRadius: CLLocationDistance = 1000,
        animated: Bool = true
    ) {
        let coordinateRegion = MKCoordinateRegion(
            center: coordinate,
            latitudinalMeters: regionRadius,
            longitudinalMeters: regionRadius
        )
        setRegion(coordinateRegion, animated: animated)
    }
    
    /// Sets map zoom level
    /// - Parameters:
    ///   - scale: Relative zoom factor applied to current map zoom.
    ///     - `2.0` will zoom in by 2x;
    ///     - `0.5` will zoom out by 2x
    ///   - animated: Should aniamte zooming or not
    func setZoom(scale: Double, animated: Bool) {
        guard scale != 0 else { return }
        var region = region
        region.span.latitudeDelta /= scale
        region.span.longitudeDelta /= scale
        guard [
            region.span.latitudeDelta,
            region.span.longitudeDelta
        ].allSatisfy({ $0 >= 0 && $0 <= 180 })
        else {
            return
        }
        guard animated else {
            self.region = region
            return
        }
        UIView.animate(withDuration: 0.3) {
            self.region = region
        }
    }
}
