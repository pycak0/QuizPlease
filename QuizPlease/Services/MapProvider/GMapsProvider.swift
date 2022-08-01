//
//  GMapsProvider.swift
//  mvd
//
//  Created by Владислав on 19.10.2020.
//  Copyright © 2020 AMG-BS. All rights reserved.
//

import UIKit
import CoreLocation

final class GMapsProvider: MapProvider {

    let title = "Google Maps"
    let urlSchema = URL(string: "comgooglemaps://")!

    func openMapRoute(to coordinate: CLLocationCoordinate2D, placeName: String?) {
        guard UIApplication.shared.canOpenURL(urlSchema) else { return }

        let urlString = "http://maps.google.com/?" +
        "daddr=\(coordinate.latitude),\(coordinate.longitude)&directionsmode=driving"

        if let url = URL(string: urlString),
           UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
}
