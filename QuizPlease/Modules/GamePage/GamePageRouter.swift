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

    /// Show user agreement screen
    func showUserAgreementScreen()

    /// Close GamePage screen
    func close()
}

/// GamePage screen router
final class GamePageRouter: GamePageRouterProtocol {

    private let webPageRouter: WebPageRouter

    /// Initialize `GamePageRouter`
    /// - Parameters:
    ///   - webPageRouter: Service that opens web pages with in-app browser
    init(webPageRouter: WebPageRouter) {
        self.webPageRouter = webPageRouter
    }

    /// View controller managed by the router
    weak var viewController: UIViewController?

    private var navigationController: UINavigationController? {
        viewController?.navigationController
    }

    func showMap(for place: Place) {
        let mapViewController = MapAssembly(place: place).makeViewController()
        viewController?.present(mapViewController, animated: true)
    }

    func showUserAgreementScreen() {
        webPageRouter.open(url: AppSettings.termsOfUseUrl, options: .autoReaderView)
    }

    func close() {
        navigationController?.popViewController(animated: true)
    }
}
