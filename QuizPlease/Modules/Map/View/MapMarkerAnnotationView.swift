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
        configure()
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        configure()
    }

    private func configure() {
        markerTintColor = .themePurple
        glyphImage = .logoTemplateImage
    }
}
