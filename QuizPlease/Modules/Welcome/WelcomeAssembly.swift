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
        let interactor = WelcomeInteractor()
        let presenter = WelcomePresenter(
            router: router,
            interactor: interactor
        )
        let viewController = WelcomeViewController(output: presenter)

        interactor.output = presenter
        presenter.view = viewController
        router.viewController = viewController

        return viewController
    }
}
