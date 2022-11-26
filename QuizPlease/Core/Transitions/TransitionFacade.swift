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

    /// Initializer
    /// - Parameter deeplinkService: Service that handles deeplinks and universal links
    init(deeplinkService: DeeplinkService) {
        self.deeplinkService = deeplinkService
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
        if handleUrl(url) {
            return true
        }
        return YKSdk.shared.handleOpen(url: url, sourceApplication: options[.sourceApplication] as? String)
    }

    /// Handle open URL contexts (method is intended to be called in the `SceneDelegate`)
    @available(iOS 13.0, *)
    func handleOpenUrlContexts(_ urlContexts: Set<UIOpenURLContext>) {
        guard let context = urlContexts.first else { return }
        logInfo("Received URL to handle")

        let url = context.url
        if handleUrl(url) {
            return
        }
        _ = YKSdk.shared.handleOpen(url: url, sourceApplication: context.options.sourceApplication)
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
    /// - Parameter url: URL of the transition, e.g. deeplink or universal link
    /// - Returns: `true`, if url was handled. Otherwise, returns `false`
    @discardableResult
    func handleUrl(_ url: URL) -> Bool {
        deeplinkService.handle(url: url)
    }

    private func logInfo(_ message: String, file: String = #fileID, function: String = #function) {
        print("[\(file)] : \(function) - \(message)")
    }
}
