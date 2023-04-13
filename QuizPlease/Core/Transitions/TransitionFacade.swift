//
//  TransitionFacade.swift
//  QuizPlease
//
//  Created by Владислав on 02.10.2022.
//  Copyright © 2022 Владислав. All rights reserved.
//

import os
import UIKit
import YooKassaPayments

/// Object that wraps transition services of the App
final class TransitionFacade {

    private let deeplinkService: DeeplinkService
    private let userNotificationsService: UserNotificationsService
    private let webPageRouter: WebPageRouter

    /// Initializer
    /// - Parameters:
    ///   - deeplinkService: Service that handles deeplinks and universal links
    ///   - userNotificationsService: Service that handles user notifications
    ///   - webPageRouter: Service that opens web pages with in-app browser
    init(
        deeplinkService: DeeplinkService,
        userNotificationsService: UserNotificationsService,
        webPageRouter: WebPageRouter
    ) {
        self.deeplinkService = deeplinkService
        self.userNotificationsService = userNotificationsService
        self.webPageRouter = webPageRouter
    }

    /// Handle Scene connection options (method is intended to be called in the `SceneDelegate`)
    @available(iOS 13.0, *)
    func handleConnectionOptions(_ connectionOptions: UIScene.ConnectionOptions) {
        handleOpenUrlContexts(connectionOptions.urlContexts)
    }

    /// Handle App launch options (method is intended to be called in the `AppDelegate`)
    func handleLaunchOptions(_ launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        guard let launchOptions = launchOptions else {
            return false
        }

        if let url = launchOptions[.url] as? URL {
            return handleUrl(url)
        }

        return false
    }

    /// Handle open URL with options (method is intended to be called in the `AppDelegate`)
    func handleOpenUrl(_ url: URL, options: [UIApplication.OpenURLOptionsKey: Any]) -> Bool {
        logInfo("Received URL to handle")
        return handleUrl(url, sourceApplication: options[.sourceApplication] as? String)
    }

    /// Handle open URL contexts (method is intended to be called in the `SceneDelegate`)
    @available(iOS 13.0, *)
    func handleOpenUrlContexts(_ urlContexts: Set<UIOpenURLContext>) {
        guard let context = urlContexts.first else { return }
        logInfo("Received URL to handle")
        handleUrl(context.url, sourceApplication: context.options.sourceApplication)
    }

    /// Handle "continue user activity" (in `AppDelegate` or `SceneDelegate`)
    @discardableResult
    func continueUserActivity(_ userActivity: NSUserActivity) -> Bool {
        guard let url = userActivity.webpageURL else {
            return false
        }
        return handleUrl(url)
    }

    /// Handle URL transition
    /// - Parameters:
    ///   - url: URL of the transition, e.g. deeplink or universal link
    ///   - sourceApplication: The bundle ID of the app that originated the request.
    /// - Returns: `true`, if url was handled. Otherwise, returns `false`
    @discardableResult
    func handleUrl(_ url: URL, sourceApplication: String? = nil) -> Bool {
        if deeplinkService.handle(url: url) {
            return true
        }
        if YKSdk.shared.handleOpen(url: url, sourceApplication: sourceApplication) {
            return true
        }
        return webPageRouter.open(url: url)
    }

    /// Handle User Notification
    /// - Parameter info: User Info dictionary containing notification data
    /// - Returns: Boolean value indicating whether notification was handled (true) or not (false)
    @discardableResult
    func handleUserNotification(info: [AnyHashable: Any]) -> Bool {
        userNotificationsService.handle(userInfo: info)
    }

    private func logInfo(_ message: String, file: String = #fileID, function: String = #function) {
        print("[\(file)] : \(function) - \(message)")
    }
}
