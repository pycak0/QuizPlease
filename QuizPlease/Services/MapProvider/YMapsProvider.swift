//
//  YMapsProvider.swift
//  mvd
//
//  Created by Владислав on 19.10.2020.
//  Copyright © 2020 AMG-BS. All rights reserved.
//

import UIKit
import CoreLocation

final class YMapsProvider: MapProvider {

    let title = "Яндекс.Карты"
    let urlSchema = URL(string: "yandexmaps://")!

    func openMapRoute(to coordinate: CLLocationCoordinate2D, placeName: String?) {

        let urlSting = "yandexmaps://build_route_on_map/?" +
        "lat_to=\(coordinate.latitude)&lon_to=\(coordinate.longitude)"

        if let url = URL(string: urlSting),
           UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
}
