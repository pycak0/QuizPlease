//
//  UITestGamePageBootstrap.swift
//  QuizPlease
//
//  Created by Codex on 07.07.2026.
//  Copyright © 2026 Владислав. All rights reserved.
//

#if DEBUG

import UIKit

enum UITestGamePageBootstrap {

    static var isEnabled: Bool {
        UITestLaunchArguments.contains(.gamePageMaxParticipants)
    }

    @available(iOS 13.0, *)
    static func presentIfNeeded(in scene: UIScene) -> Bool {
        guard isEnabled, let windowScene = scene as? UIWindowScene else { return false }

        configureServices()

        let viewController = GamePageAssembly(
            launchOptions: GamePageLaunchOptions(
                gameId: UITestGameFixtures.maxParticipantsGameId,
                shouldScrollToRegistration: true
            )
        ).makeViewController()
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
        services.placeGeocoder = UITestPlaceGeocoder()
        services.gameInfoLoader = UITestGameInfoLoader(game: UITestGameFixtures.maxParticipantsGame())
    }
}

#endif
