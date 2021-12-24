//
//  AppleMapsProvider.swift
//  mvd
//
//  Created by Владислав on 19.10.2020.
//  Copyright © 2020 AMG-BS. All rights reserved.
//

import UIKit
import MapKit

class AppleMapsProvider: MapProvider {
    
    let title = "Apple Карты"
    let urlSchema = URL(string: "https://maps.apple.com/")! 
    
    func openMapRoute(to coordinate: CLLocationCoordinate2D, placeName: String?) {
        let options = [
            MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving
        ]
        
        let destinationPlacemark = MKPlacemark(coordinate: coordinate)
        let destinationMapItem = MKMapItem(placemark: destinationPlacemark)
        destinationMapItem.name = placeName ?? "Место назначения"
        
        destinationMapItem.openInMaps(launchOptions: options)
    }
}
