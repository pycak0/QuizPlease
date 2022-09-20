//
//  MapMarkerAnnotationView.swift
//  QuizPlease
//
//  Created by Владислав on 20.09.2022.
//  Copyright © 2022 Владислав. All rights reserved.
//

import MapKit

final class MapMarkerAnnotationView: MKMarkerAnnotationView {

    // MARK: - Lifecycle

    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        markerTintColor = .themePurple
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
