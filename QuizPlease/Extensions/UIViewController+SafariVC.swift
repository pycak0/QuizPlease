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
    //MARK:- Open Safari VC with link
    ///Opens Safari screen with chosen preset link or any other given
    func openSafariVC(_ delegate: SFSafariViewControllerDelegate, with url: URL, autoReaderView: Bool = true, barsColor: UIColor? = nil, controlsTintColor: UIColor? = nil, presentationStyle: UIModalPresentationStyle = .overFullScreen) {
        
        let config = SFSafariViewController.Configuration()
        config.entersReaderIfAvailable = autoReaderView
        
        let vc = SFSafariViewController(url: url, configuration: config)
        vc.delegate = delegate
        vc.preferredControlTintColor = controlsTintColor
        vc.preferredBarTintColor = barsColor
        vc.modalPresentationStyle = presentationStyle
            
        present(vc, animated: true, completion: nil)
    }
}

