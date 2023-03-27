//
//  WelcomeRouter.swift
//  QuizPlease
//
//  Created by Владислав on 23.03.2023.
//  Copyright © 2023 Владислав. All rights reserved.
//

import UIKit

/// Welcome screen router protocol
protocol WelcomeRouterProtocol {

    /// Show city picker view controller
    func showCityPicker(selectedCity: City?, delegate: PickCityVCDelegate?)

    /// Show main menu
    func showMainMenu()
}

/// Welcome screen router
final class WelcomeRouter {

    weak var viewController: UIViewController?
    private let pickCityAssembly: PickCityAssembly

    /// Initialize WelcomeRouter
    /// - Parameters:
    ///   - pickCityAssembly: PickCity ViewController Assembly
    init(
        pickCityAssembly: PickCityAssembly
    ) {
        self.pickCityAssembly = pickCityAssembly
    }
}

// MARK: - WelcomeRouterProtocol

extension WelcomeRouter: WelcomeRouterProtocol {

    func showCityPicker(selectedCity: City?, delegate: PickCityVCDelegate?) {
        let pickCityVC = pickCityAssembly.makePickCityViewController(
            selectedCity: selectedCity,
            delegate: delegate
        )
        viewController?.present(pickCityVC, animated: true)
    }

    func showMainMenu() {
        let mainMenuViewController = UIStoryboard.main.instantiateViewController(
            withIdentifier: "MainMenuNavigationController"
        )
        UIApplication.shared
            .getKeyWindow()?
            .setRootViewControllerWithAnimation(rootViewController: mainMenuViewController)
    }
}
