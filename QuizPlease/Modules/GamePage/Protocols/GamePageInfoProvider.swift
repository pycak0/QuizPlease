//
//  GamePageInfoProvider.swift
//  QuizPlease
//
//  Created by Русаков Владислав Андреевич on 13.04.2023.
//  Copyright © 2023 Владислав. All rights reserved.
//

import Foundation

/// GamePage game info provider protocol
protocol GamePageInfoProvider: GamePageInfoPlaceProvider {

    /// Get Game basic info
    func getInfo() -> GamePageInfoModel
}

/// Service that provides `Place` annotation with coordinates
protocol GamePageInfoPlaceProvider {

    /// Get place annotation to put on the map
    /// - Parameter completion: closure that contains a `Place` instance
    func getPlace(completion: @escaping (Place) -> Void)
}
