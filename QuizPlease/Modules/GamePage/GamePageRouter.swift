//
//  GamePageRouter.swift
//  QuizPlease
//
//  Created by Владислав on 13.04.2023.
//  Copyright © 2023 Владислав. All rights reserved.
//

import UIKit

/// GamePage screen router protocol
protocol GamePageRouterProtocol: AnyObject {

    /// Show Map screen with given Place annotation
    /// - Parameter place: Place annotation
    func showMap(for place: Place)

    /// Show user agreement screen
    func showUserAgreementScreen()

    /// Show the given url
    /// - Parameter url: url
    func show(url: URL)

    func showCompletionScreen(
        options: GameRegistrationResult.Options,
        delegate: GameOrderCompletionDelegate
    )

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

    func show(url: URL) {
        webPageRouter.open(url: url)
    }

    func showCompletionScreen(
        options: GameRegistrationResult.Options,
        delegate: GameOrderCompletionDelegate
    ) {
        guard let completionViewController = UIStoryboard.main.instantiateViewController(
            withIdentifier: "\(GameOrderCompletionVC.self)"
        ) as? GameOrderCompletionVC else {
            return
        }
        completionViewController.gameInfo = options.gameInfo
        completionViewController.numberOfPeopleInTeam = options.teamCount
        completionViewController.delegate = delegate

        let navigationController = UINavigationController(rootViewController: completionViewController)
        navigationController.modalPresentationStyle = .fullScreen
        viewController?.present(navigationController, animated: true)
    }

    func close() {
        navigationController?.popViewController(animated: true)
    }
}
