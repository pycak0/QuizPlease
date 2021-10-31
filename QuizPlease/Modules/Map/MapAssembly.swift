//
//  MapAssembly.swift
//  QuizPlease
//
//  Created by Владислав on 01.11.2021.
//  Copyright © 2021 Владислав. All rights reserved.
//

import UIKit

class MapAssembly: ViewAssembly {
    
    let place: Place
    
    init(place: Place) {
        self.place = place
    }
    
    /// Make map screen
    func makeViewController() -> UIViewController {
        let interactor = MapInteractor(
            place: place,
            geocoder: DefaultGeocoder(),
            locationAuthService: UserLocationService.shared
        )
        let router = MapRouter(
            providers: [
                AppleMapsProvider(),
                GMapsProvider(),
                DGisMapProvier(),
                YMapsProvider(),
                YNMapProvider()
            ]
        )
        let presenter = MapPresenter(
            interactor: interactor,
            router: router
        )
        let viewController = MapViewController(output: presenter)
        presenter.view = viewController
        router.viewController = viewController
        viewController.modalPresentationStyle = .fullScreen
        return viewController
    }
}
