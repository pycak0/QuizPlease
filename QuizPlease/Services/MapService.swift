//
//  MapService.swift
//  MetroStationsInfo
//
//  Created by Владислав on 12.08.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import Foundation
import MapKit

class MapService {
    //singleton
    private init() {}
    
    //MARK:- Open with coordinates
    ///- parameter radius: Part of map to be shown around the target point (in meters)
    static func openMap(for placeName: String, withLongitude lon: Double, andLatitude lat: Double, radius: Double = 1000) {

        let latitude: CLLocationDegrees = lat
        let longitude: CLLocationDegrees = lon

        let regionDistance: CLLocationDistance = radius
        let coordinates = CLLocationCoordinate2DMake(latitude, longitude)
        let regionSpan = MKCoordinateRegion(center: coordinates,
                                            latitudinalMeters: regionDistance,
                                            longitudinalMeters: regionDistance)
        let options = [
            MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
            MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
        ]
        let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = placeName
        mapItem.openInMaps(launchOptions: options)
    }
    
    //MARK:- Open with Address string
    static func openMap(for placeName: String, withAddress address: String, radius: Double = 1000) {
        getCoordinates(from: address) { (location) in
            guard let location = location else { return }
            openMap(for: placeName, withLongitude: location.longitude, andLatitude: location.latitude, radius: radius)
        }
    }
    
    //MARK:- Get Coordinates
    static func getCoordinates(from address: String, completion: @escaping (CLLocationCoordinate2D?) -> Void) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address) {
            (placemarks, error) in
            guard error == nil else {
                print("Geocoding error: \(error!)")
                completion(nil)
                return
            }
            completion(placemarks?.first?.location?.coordinate)
        }
    }
    
}
