//
//  MapRouter.swift
//  QuizPlease
//
//  Created by Владислав on 01.11.2021.
//  Copyright © 2021 Владислав. All rights reserved.
//

import UIKit

/// Map Router protocol
protocol MapRouterProtocol: AnyObject {

    /// Opens a map app with a route to given place
    func openMapWithRoute(to place: Place)

    /// Closes map screen
    func close()
}

final class MapRouter: MapRouterProtocol {

    weak var viewController: UIViewController?
    let providers: [MapProvider]

    /// Create a new `MapRouter` instance
    /// - Parameter providers: Map app providers to build navigation routes
    init(providers: [MapProvider]) {
        self.providers = providers
            .filter { UIApplication.shared.canOpenURL($0.urlSchema) }
    }

    func openMapWithRoute(to place: Place) {
        let alert = UIAlertController(
            title: "В каком приложении хотите построить маршрут?",
            message: nil,
            preferredStyle: .actionSheet
        )
        providers.forEach { provider in
            let action = UIAlertAction(title: provider.title, style: .default) { _ in
                provider.openMapRoute(
                    to: place.coordinate,
                    placeName: place.title
                )
            }
            alert.addAction(action)
        }
        alert.addAction(.cancel)
        alert.view.tintColor = .labelAdapted
        viewController?.present(alert, animated: true)
    }

    func close() {
        viewController?.dismiss(animated: true)
    }
}
