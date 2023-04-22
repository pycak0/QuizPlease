//
//  WebPageRouter.swift
//  QuizPlease
//
//  Created by Владислав on 13.04.2023.
//  Copyright © 2023 Владислав. All rights reserved.
//

import SafariServices

/// Service that opens web pages with in-app browser
protocol WebPageRouter {

    /// Open url via in-app browser
    /// - Parameters:
    ///   - url: web page url
    ///   - options: Options to open url in browser
    /// - Returns: `true`, if the url was opened. Otherwise, returns `false`
    @discardableResult
    func open(url: URL, options: WepPageBrowserOptions?) -> Bool
}

extension WebPageRouter {

    /// Open url via in-app browser
    /// - Parameters:
    ///   - url: web page url
    /// - Returns: `true`, if the url was opened. Otherwise, returns `false`
    @discardableResult
    func open(url: URL) -> Bool {
        open(url: url, options: nil)
    }
}

/// Service that opens web pages with in-app browser
final class WebPageRouterImpl: NSObject, WebPageRouter {

    // MARK: - WebPageRouter

    @discardableResult
    func open(url: URL, options: WepPageBrowserOptions?) -> Bool {
        guard let viewController = UIApplication.shared
            .getKeyWindow()?
            .topViewController
        else {
            return false
        }

        let options = options ?? WepPageBrowserOptions()
        let config = SFSafariViewController.Configuration()
        config.entersReaderIfAvailable = options.autoReaderView

        let safariViewController = SFSafariViewController(url: url, configuration: config)
        safariViewController.delegate = self
        safariViewController.preferredControlTintColor = options.controlsColor
        safariViewController.preferredBarTintColor = options.barsColor

        if #available(iOS 13.0, *) {
            safariViewController.modalPresentationStyle = .automatic
            safariViewController.isModalInPresentation = true
        } else {
            safariViewController.modalPresentationStyle = .pageSheet
        }

        viewController.present(safariViewController, animated: true)
        return true
    }
}

// MARK: - SFSafariViewControllerDelegate

extension WebPageRouterImpl: SFSafariViewControllerDelegate {
}
