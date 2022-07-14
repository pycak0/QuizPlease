//
//  UIViewController+SafariVC.swift
//  QuizPlease
//
//  Created by Владислав on 27.11.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import UIKit
import SafariServices

extension UIViewController {
    // MARK: - Open Safari VC with link
    /// Opens Safari screen with chosen preset link or any other given
    /// - parameter url: if `nil`, will not open anything
    func openSafariVC(
        with url: URL?,
        delegate: SFSafariViewControllerDelegate?,
        autoReaderView: Bool = false,
        barsColor: UIColor! = .purple,
        controlsColor: UIColor = .white
    ) {
        guard let url = url else { return }

        let config = SFSafariViewController.Configuration()
        config.entersReaderIfAvailable = autoReaderView

        let safariViewController = SFSafariViewController(url: url, configuration: config)
        safariViewController.delegate = delegate
        safariViewController.preferredControlTintColor = controlsColor
        safariViewController.preferredBarTintColor = barsColor
        if #available(iOS 13.0, *) {
            safariViewController.modalPresentationStyle = .automatic
            safariViewController.isModalInPresentation = true
        } else {
            safariViewController.modalPresentationStyle = .pageSheet
        }
        present(safariViewController, animated: true, completion: nil)
    }
}
