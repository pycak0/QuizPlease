//
//  YNMapProvider.swift
//  mvd
//
//  Created by Владислав on 19.10.2020.
//  Copyright © 2020 AMG-BS. All rights reserved.
//

import UIKit
import CoreLocation

class YNMapProvider: MapProvider {
    
    let title = "Яндекс.Навигатор"
    let urlSchema = URL(string: "yandexnavi://")!
    
    func openMapRoute(to coordinate: CLLocationCoordinate2D, placeName: String?) {
        guard UIApplication.shared.canOpenURL(urlSchema) else { return }
        
        if let url = URL(string: "yandexnavi://build_route_on_map?lat_to=\(coordinate.latitude)&lon_to=\(coordinate.longitude)") {
            UIApplication.shared.open(url)
        }
    }
}
