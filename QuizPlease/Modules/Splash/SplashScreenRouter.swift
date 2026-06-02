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

    /// Show consent screen as a sheet over the splash
    func showConsentScreen(onAccepted: @escaping () -> Void)

    /// Show alert with prompt to update the app
    func showUpdateAlert(forceUpate: Bool, onUpdate: (() -> Void)?, onSkip: (() -> Void)?)

    /// Open web browser with given url
    func open(url: URL)
}

/// SplashScreen router
final class SplashScreenRouter: SplashScreenRouterProtocol {

    weak var viewController: UIViewController?

    private let welcomeAssembly: WelcomeAssembly
    private let consentAssembly: ConsentAssembly

    init(welcomeAssembly: WelcomeAssembly, consentAssembly: ConsentAssembly) {
        self.welcomeAssembly = welcomeAssembly
        self.consentAssembly = consentAssembly
    }

    func showWelcomeScreen() {
        let welcomeViewController = welcomeAssembly.makeViewController()
        UIApplication.shared
            .getKeyWindow()?
            .setRootViewControllerWithAnimation(rootViewController: welcomeViewController)
    }

    func showConsentScreen(onAccepted: @escaping () -> Void) {
        let consentVC = consentAssembly.makeViewController(onAccepted: onAccepted)
        viewController?.present(consentVC, animated: true)
    }

    func showMainMenu() {
        let mainMenuViewController = UIStoryboard.main.instantiateViewController(
            withIdentifier: "MainMenuNavigationController"
        )
        UIApplication.shared
            .getKeyWindow()?
            .setRootViewControllerWithAnimation(rootViewController: mainMenuViewController)
    }

    func showUpdateAlert(forceUpate: Bool, onUpdate: (() -> Void)?, onSkip: (() -> Void)?) {
        let alert = QPAlert(title: "Пора прокачать приложение до последней версии!")
            .withPrimaryButton(title: "Обновить", action: onUpdate)

        if !forceUpate {
            alert.addBasicButton(title: "Позже") { [alert] in
                alert.hide {
                    onSkip?()
                }
            }
        }

        alert.show()
    }

    func open(url: URL) {
        // No need to open update url via in-app browser,
        // so we are not using WebPageRouter here.
        UIApplication.shared.open(url)
    }
}
