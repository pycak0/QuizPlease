//
//  GamePageRouter.swift
//  QuizPlease
//
//  Created by Владислав on 13.04.2023.
//  Copyright © 2023 Владислав. All rights reserved.
//

import UIKit

/// GamePage screen router protocol
protocol GamePageRouterProtocol {

    /// Show Map screen with given Place annotation
    /// - Parameter place: Place annotation
    func showMap(for place: Place)

    /// Close GamePage screen
    func close()
}

/// GamePage screen router
final class GamePageRouter: GamePageRouterProtocol {

    /// View controller managed by the router
    weak var viewController: UIViewController?

    private var navigationController: UINavigationController? {
        viewController?.navigationController
    }

    func showMap(for place: Place) {
        let mapViewController = MapAssembly(place: place).makeViewController()
        viewController?.present(mapViewController, animated: true)
    }

    func close() {
        navigationController?.popViewController(animated: true)
    }
}
