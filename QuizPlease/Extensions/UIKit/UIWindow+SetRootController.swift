//
//  UIWindow+SetRootController.swift
//  QuizPlease
//
//  Created by Владислав on 24.03.2023.
//  Copyright © 2023 Владислав. All rights reserved.
//

import UIKit

extension UIWindow {

    /// Sets new root view controller, makes it key and visible
    /// and adds transition animation to the process.
    func setRootViewControllerWithAnimation(
        rootViewController: UIViewController,
        duration: CGFloat = 0.3,
        options: UIView.AnimationOptions = .transitionCrossDissolve
    ) {
        self.rootViewController = rootViewController
        self.makeKeyAndVisible()
        UIView.transition(
            with: self,
            duration: duration,
            options: options,
            animations: nil,
            completion: nil
        )
    }
}
