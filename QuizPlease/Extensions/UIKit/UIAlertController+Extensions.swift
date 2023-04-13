//
//  UIAlertController+Extensions.swift
//  QuizPlease
//
//  Created by Владислав on 07.08.2022.
//  Copyright © 2022 Владислав. All rights reserved.
//

import UIKit

extension UIAlertController {

    /// Add an action to the current alert and return the instance.
    /// - Parameter action: An action that can be taken when the user taps a button in an alert.
    /// - Returns: An instance of this controller with added action.
    func withAction(_ action: UIAlertAction) -> Self {
        addAction(action)
        return self
    }

    /// Add an action to the current alert and return the instance.
    /// - Parameters:
    ///   - title: The text to use for the button title.
    ///   - style: Additional styling information to apply to the button.
    ///   - handler: A block to execute when the user selects the action.
    /// - Returns: An instance of this controller with added action.
    func withAction(
        title: String?,
        style: UIAlertAction.Style = .default,
        handler: (() -> Void)? = nil
    ) -> Self {
        withAction(UIAlertAction(
            title: title,
            style: style,
            handler: { _ in handler?() }
        ))
    }

    /// Present the alert on the top view controller of the key `UIWindow` of the app.
    func show() {
        UIApplication.shared
            .getKeyWindow()?
            .topViewController?
            .present(self, animated: true)
    }
}
