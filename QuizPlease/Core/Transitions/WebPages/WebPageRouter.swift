//
//  WebPageRouter.swift
//  QuizPlease
//
//  Created by Владислав on 13.04.2023.
//  Copyright © 2023 Владислав. All rights reserved.
//

import SafariServices
import UIKit

protocol WebPageRoutingApplication {
    var topViewController: UIViewController? { get }
    func canOpenURL(_ url: URL) -> Bool
    func openExternalURL(_ url: URL)
}

extension UIApplication: WebPageRoutingApplication {
    var topViewController: UIViewController? {
        getKeyWindow()?.topViewController
    }

    func openExternalURL(_ url: URL) {
        open(url)
    }
}

/// Service that opens web pages
protocol WebPageRouter {

    /// Open url
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

/// Service that opens web pages
final class WebPageRouterImpl: NSObject, WebPageRouter {

    private let application: WebPageRoutingApplication

    init(application: WebPageRoutingApplication = UIApplication.shared) {
        self.application = application
    }

    // MARK: - WebPageRouter

    @discardableResult
    func open(url: URL, options: WepPageBrowserOptions?) -> Bool {
        let options = options ?? WepPageBrowserOptions()

        switch options.openingMode {
        case .externalBrowser:
            guard application.canOpenURL(url) else { return false }
            application.openExternalURL(url)
            return true

        case .inAppBrowser:
            return openInAppBrowser(url: url, options: options)
        }
    }

    private func openInAppBrowser(url: URL, options: WepPageBrowserOptions) -> Bool {
        guard let viewController = application.topViewController else {
            return false
        }

        let config = SFSafariViewController.Configuration()
        config.entersReaderIfAvailable = options.autoReaderView

        let safariViewController = SFSafariViewController(url: url, configuration: config)
        safariViewController.delegate = self
        safariViewController.preferredControlTintColor = options.controlsColor
        safariViewController.preferredBarTintColor = options.barsColor
        safariViewController.modalPresentationStyle = options.presentationStyle
        safariViewController.isModalInPresentation = true

        viewController.present(safariViewController, animated: true)
        return true
    }
}

// MARK: - SFSafariViewControllerDelegate

extension WebPageRouterImpl: SFSafariViewControllerDelegate {
}
