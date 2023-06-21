//
//  UIWindow+topViewController.swift
//  QuizPlease
//
//  Created by Владислав on 10.08.2021.
//  Copyright © 2021 Владислав. All rights reserved.
//

import UIKit

extension UIWindow {

    /// The top-most `UIViewController` in the controller hierarchy of the App
    var topViewController: UIViewController? {
        var topController = rootViewController
        while let presentedViewController = topController?.presentedViewController {
            topController = presentedViewController
        }
        return topController
    }

    /// The top-most `UINavigationController` in the controller hierarchy of the App
    var topNavigationController: UINavigationController? {
        var topNavigationController = rootViewController
        while let presentedNavController = topNavigationController?.presentedViewController as? UINavigationController {
            topNavigationController = presentedNavController
        }
        return topNavigationController as? UINavigationController
    }
}
