//
//  MapService.swift
//  MetroStationsInfo
//
//  Created by Владислав on 12.08.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import Foundation
import MapKit

final class MapService {
    // singleton
    private init() {}

    // MARK: - Open with coordinates
    /// Wrapper for method `openAppleMaps(for:withLongitude:andLatitude:radius:)`
    static func openAppleMaps(
        for placeName: String,
        withCoordinate coord: CLLocationCoordinate2D,
        regionRadius: Double = 1000
    ) {
        openAppleMaps(
            for: placeName,
            withLongitude: coord.longitude,
            andLatitude: coord.latitude,
            radius: regionRadius
        )
    }

    /// Opens Apple Maps with given parameters
    /// - parameter radius: Part of map to be shown around the target point (in meters)
    static func openAppleMaps(
        for placeName: String,
        withLongitude lon: Double,
        andLatitude lat: Double,
        radius: Double = 1000
    ) {
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

    // MARK: - Open with Address string

    static func getCoordinatesAndOpenMap(
        for placeName: String,
        withAddress address: String,
        radius: Double = 1000,
        completion: ((Error?) -> Void)?
    ) {
        getCoordinates(from: address) { (location) in
            guard let location = location else {
                let error = NSError(
                    domain: "Map wasn't open because geocoder failed to load the location " +
                    "from given address: '\(address)'",
                    code: 8
                )
                completion?(error)
                return
            }

            openAppleMaps(
                for: placeName,
                withLongitude: location.longitude,
                andLatitude: location.latitude,
                radius: radius
            )
            completion?(nil)
        }
    }

    // MARK: - Get Coordinates

    static func getCoordinates(from address: String, completion: @escaping (CLLocationCoordinate2D?) -> Void) {
        getLocation(from: address) { (location) in
            completion(location?.coordinate)
        }
    }

    static func getLocation(from address: String, completion: @escaping (CLLocation?) -> Void) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address) { placemarks, error in
            if let error = error {
                print("[\(Self.self) error]. Tried to geocode address: '\(address)', but got error: \(error)")
                completion(nil)
                return
            }
            completion(placemarks?.first?.location)
        }
    }
}
