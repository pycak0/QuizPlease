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
    ///Opens Safari screen with chosen preset link or any other given
    ///- parameter url: if `nil`, will not open anything
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
        
        let vc = SFSafariViewController(url: url, configuration: config)
        vc.delegate = delegate
        vc.preferredControlTintColor = controlsColor
        vc.preferredBarTintColor = barsColor
        if #available(iOS 13.0, *) {
            vc.modalPresentationStyle = .automatic
            vc.isModalInPresentation = true
        } else {
            vc.modalPresentationStyle = .pageSheet
        }
        present(vc, animated: true, completion: nil)
    }
}

