//
//  GamePageInfoPlaceProvider.swift
//  QuizPlease
//
//  Created by Русаков Владислав Андреевич on 12.04.2023.
//  Copyright © 2023 Владислав. All rights reserved.
//

import Foundation

/// Service that provides `Place` annotation with coordinates
protocol GamePageInfoPlaceProvider {

    /// Method tries to geocode location based on the place properties such as address or city name
    /// - Parameter completion: closure that contains a `Place` instance
    func getPlace(completion: @escaping (Place) -> Void)
}
