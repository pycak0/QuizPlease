//
//  DGisMapProvier.swift
//  mvd
//
//  Created by Владислав on 19.10.2020.
//  Copyright © 2020 AMG-BS. All rights reserved.
//

import UIKit
import CoreLocation

class DGisMapProvier: MapProvider {

    let title = "2ГИС"
    let urlSchema = URL(string: "dgis://")!

    func openMapRoute(to coordinate: CLLocationCoordinate2D, placeName: String?) {
        guard UIApplication.shared.canOpenURL(urlSchema) else { return }

        if let url = URL(string: "dgis://2gis.ru/routeSearch/rsType/car/to/\(coordinate.longitude),\(coordinate.latitude)") {
            UIApplication.shared.open(url)
        }

    }
}
