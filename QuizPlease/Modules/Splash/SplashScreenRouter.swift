//
//  SplashScreenRouter.swift
//  QuizPlease
//
//  Created by Владислав on 12.04.2021.
//  Copyright © 2021 Владислав. All rights reserved.
//

import UIKit

/// SplashScreen router protocol
protocol SplashScreenRouterProtocol {

    /// Show Main Menu
    func showMainMenu()

    /// Show Welcome Screen
    func showWelcomeScreen()
}

/// SplashScreen router
final class SplashScreenRouter: SplashScreenRouterProtocol {

    weak var viewController: UIViewController?

    private let welcomeAssembly: WelcomeAssembly

    init(welcomeAssembly: WelcomeAssembly) {
        self.welcomeAssembly = welcomeAssembly
    }

    func showWelcomeScreen() {
        let welcomeViewController = welcomeAssembly.makeViewController()
        UIApplication.shared
            .getKeyWindow()?
            .setRootViewControllerWithAnimation(rootViewController: welcomeViewController)
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
