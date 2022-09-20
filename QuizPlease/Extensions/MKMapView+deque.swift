//
//  MKMapView+deque.swift
//  QuizPlease
//
//  Created by Владислав on 20.09.2022.
//  Copyright © 2022 Владислав. All rights reserved.
//

import MapKit

extension MKMapView {

    /// Dequeues a reusable annotation view object identified by its class name.
    ///
    /// - Parameters:
    ///   - viewClass: View class
    ///   - annotation: The annotation being displayed.
    ///   For more details, see ohter MKMapView `dequeueReusableAnnotationView` methods' documentation.
    /// - Returns: A specified `ViewClass` object that inherits `MKAnnotationView`.
    ///
    /// If mapView could not create an object of given type, throws `assertionFailure` in debug mode
    /// and instantiates a default ViewClass view in release mode.
    func dequeueReusableAnnotationView<ViewClass: MKAnnotationView>(
        _ viewClass: ViewClass.Type,
        for annotation: MKAnnotation
    ) -> ViewClass {
        guard let view = dequeueReusableAnnotationView(
            withIdentifier: "\(ViewClass.self)",
            for: annotation
        ) as? ViewClass else {
            assertionFailure("❌ Invalid view kind!")
            return ViewClass.init()
        }
        return view
    }
}
