//
//  UIViewController+StatusBarStyle.swift
//  QuizPlease
//
//  Created by Владислав on 18.09.2022.
//  Copyright © 2022 Владислав. All rights reserved.
//

import UIKit

extension UINavigationController {

    open override var childForStatusBarStyle: UIViewController? {
        topViewController?.childForStatusBarStyle ?? topViewController
    }
}

extension UITabBarController {

    open override var childForStatusBarStyle: UIViewController? {
        selectedViewController?.childForStatusBarStyle ?? selectedViewController
    }
}
