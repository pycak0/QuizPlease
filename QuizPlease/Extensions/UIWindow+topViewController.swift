//
//  UIWindow+topViewController.swift
//  QuizPlease
//
//  Created by Владислав on 10.08.2021.
//  Copyright © 2021 Владислав. All rights reserved.
//

import UIKit

extension UIWindow {
    var topViewController: UIViewController? {
        var topController = rootViewController
        while let presentedViewController = topController?.presentedViewController {
            topController = presentedViewController
        }
        return topController
    }
}
