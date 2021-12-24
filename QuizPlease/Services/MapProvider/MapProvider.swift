//
//  MapProvider.swift
//  mvd
//
//  Created by Владислав on 19.10.2020.
//  Copyright © 2020 AMG-BS. All rights reserved.
//

import CoreLocation

/// An object that opens a Map app with a route to given destination point
protocol MapProvider: AnyObject {
    
    /// Title of Map app
    var title: String { get }
    
    /// URL schema to check if app can open this Map App
    var urlSchema: URL { get }
    
    /// Map opening strategy
    /// - Parameters:
    ///   - coordinate: Destination point
    ///   - placeName: Title of destination point
    func openMapRoute(to coordinate: CLLocationCoordinate2D, placeName: String?)
}
