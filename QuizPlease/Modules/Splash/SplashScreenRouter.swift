//
//  SplashScreenRouter.swift
//  QuizPlease
//
//  Created by Владислав on 12.04.2021.
//  Copyright © 2021 Владислав. All rights reserved.
//

import UIKit

/// SplashScreen router protocol
protocol SplashScreenRouterProtocol: Router {

    /// Show Main Menu
    func showMainMenu()

    /// Show Welcome Screen
    func showWelcomeScreen()
}

/// SplashScreen router
final class SplashScreenRouter: SplashScreenRouterProtocol {

    private let welcomeAssembly: WelcomeAssembly
    unowned let viewController: UIViewController

    init(
        viewController: UIViewController,
        welcomeAssembly: WelcomeAssembly
    ) {
        self.viewController = viewController
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
