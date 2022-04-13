//
//  QPNavigationController.swift
//  QuizPlease
//
//  Created by Владислав on 29.10.2021.
//  Copyright © 2021 Владислав. All rights reserved.
//

import UIKit

/// QuizPleaze Navigaton Controller
///
/// Key features:
/// - full-width swipe back gesture recognizer
/// - (maybe in the future) stylable navigation bar
class QPNavigationController: UINavigationController {
    
    let fullWidthSwipeBackGestureRecognizer = UIPanGestureRecognizer()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    private func setupSwipeBackGestureRecognizer() {
        if let interactivePopGestureRecognizer = interactivePopGestureRecognizer, let targets = interactivePopGestureRecognizer.value(forKey: "targets") {
            fullWidthSwipeBackGestureRecognizer.setValue(targets, forKey: "targets")
            view.addGestureRecognizer(fullWidthSwipeBackGestureRecognizer)
            if #available(iOS 13.4, *) {
                fullWidthSwipeBackGestureRecognizer.allowedScrollTypesMask = .continuous
            }
        }
    }
}
