//
//  UITestRatingBootstrap.swift
//  QuizPlease
//
//  Created by Codex on 09.07.2026.
//  Copyright © 2026 Владислав. All rights reserved.
//

#if DEBUG

import UIKit

enum UITestRatingBootstrap: UITestBootstrapScenario {

    static var isEnabled: Bool {
        UITestLaunchArguments.contains(.ratingSeason)
    }

    @available(iOS 13.0, *)
    static func presentIfNeeded(in scene: UIScene) -> Bool {
        guard isEnabled, let windowScene = scene as? UIWindowScene else { return false }

        configureServices()

        let viewController = UIStoryboard.main.instantiateViewController(
            withIdentifier: "RatingVC"
        )
        let navigationController = QPNavigationController(rootViewController: viewController)

        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = navigationController
        window.makeKeyAndVisible()

        (UIApplication.shared.delegate as? AppDelegate)?.window = window
        (windowScene.delegate as? SceneDelegate)?.window = window
        return true
    }

    private static func configureServices() {
        let services = ServiceAssembly.shared
        services.analytics = UITestAnalyticsService()
        services.networkService = UITestRatingNetworkService()
    }
}

#endif
