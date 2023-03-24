//
//  WelcomeAssembly.swift
//  QuizPlease
//
//  Created by Владислав on 23.03.2023.
//  Copyright © 2023 Владислав. All rights reserved.
//

import UIKit

/// Welcome screen assembly
final class WelcomeAssembly {

    /// Make Welcome view controller
    func makeViewController() -> UIViewController {
        let router = WelcomeRouter(pickCityAssembly: PickCityAssembly())
        let presenter = WelcomePresenter(router: router)
        let viewController = WelcomeViewController(output: presenter)
        presenter.view = viewController
        router.viewController = viewController
        return viewController
    }
}
