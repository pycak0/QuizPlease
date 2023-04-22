//
//  CoreAssembly.swift
//  QuizPlease
//
//  Created by Владислав on 02.10.2022.
//  Copyright © 2022 Владислав. All rights reserved.
//

import Foundation

/// Object that assembles Core tools of the App
final class CoreAssembly {

    /// `CoreAssembly` shared instance
    static let shared = CoreAssembly()

    /// Singleton
    private init() { }

    /// Object that wraps transition services of the App
    lazy var transitionFacade = TransitionFacade(
        deeplinkService: deeplinkService,
        userNotificationsService: userNotificationsService,
        webPageRouter: webPageRouter
    )

    /// Service that handles user notifications
    lazy var userNotificationsService: UserNotificationsService = UserNotificationsServiceImpl(
        deeplinkService: deeplinkService,
        applinkRouter: applinkRouter
    )

    /// Service that handles deeplinks and universal links
    lazy var deeplinkService: DeeplinkService = DeeplinkServiceImpl(
        deeplinkParser: deeplinkParser,
        applinkRouter: applinkRouter
    )

    /// Service that parses URL (deeplink or universal link) to DeeplinkKind
    lazy var deeplinkParser: DeeplinkParser = DeeplinkParserImpl()

    /// Object that manages routing with Applinks
    lazy var applinkRouter: ApplinkRouter = ApplinkRouterImpl(
        webPageRouter: webPageRouter
    )

    /// Service that opens web pages with in-app browser
    lazy var webPageRouter: WebPageRouter = WebPageRouterImpl()
}
