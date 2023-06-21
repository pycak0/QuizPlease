//
//  UIAlertAction+Static.swift
//  QuizPlease
//
//  Created by Владислав on 07.11.2021.
//  Copyright © 2021 Владислав. All rights reserved.
//

import UIKit

extension UIAlertAction {

    /// Creates a new instance with `title: "Отмена", style: .cancel, handler: nil`.
    class var cancel: UIAlertAction {
        UIAlertAction(title: "Отмена", style: .cancel)
    }

    /// Creates a new alert action with `cancel` style.
    /// - Parameters:
    ///   - title: The text to use for the button title.
    ///   - handler: A block to execute when the user selects the action.
    /// - Returns: A new instance with given `title`, `style: .cancel` and an optional `handler`.
    class func cancel(title: String, handler: (() -> Void)? = nil) -> UIAlertAction {
        UIAlertAction(title: title, style: .cancel, handler: { _ in handler?() })
    }

    /// Creates a new "delete" alert action.
    /// - Parameter onTap: A block to execute when the user selects the action.
    /// - Returns: A new instance with `title: "Удалить", style: .destructive` and an optional `handler`.
    class func delete(onTap: (() -> Void)?) -> UIAlertAction {
        destructive(title: "Удалить", handler: onTap)
    }

    /// Creates a new destructive alert action.
    /// - Parameters:
    ///   - title: The text to use for the button title.
    ///   - handler: A block to execute when the user selects the action.
    /// - Returns: A new instance with given `title`, `style: .destructive` and an optional `handler`.
    class func destructive(title: String, handler: (() -> Void)? = nil) -> UIAlertAction {
        UIAlertAction(title: title, style: .destructive, handler: { _ in handler?() })
    }
}
