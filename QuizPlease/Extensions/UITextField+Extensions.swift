//
//  UITextField+Extensions.swift
//  QuizPlease
//
//  Created by Владислав on 19.05.2021.
//  Copyright © 2021 Владислав. All rights reserved.
//

import UIKit

public extension UITextField {
    // MARK: - Placeholder color
    @IBInspectable var placeholderColor: UIColor? {
        get {
            return self.attributedPlaceholder?.attribute(.foregroundColor, at: 0, effectiveRange: nil) as? UIColor
        }
        set {
            self.attributedPlaceholder = NSAttributedString(
                string: self.placeholder ?? "",
                attributes: [.foregroundColor: newValue!]
            )
        }
    }

    // MARK: - Set Image

    /// - parameter side: Preferred width and height of image's `CGrect` (the shape is a square).
    /// - parameter textPadding: Image inset from textField's text
    /// - parameter edgePadding: Image inset from textField's left side. The default is equal to `textPadding` value
    func setImage(_ image: UIImage?, side: CGFloat = 20, textPadding: CGFloat = 16, edgePadding: CGFloat? = nil) {

        let yOffset = (bounds.height - side) / 2
        let iconView = UIImageView(frame: CGRect(x: edgePadding ?? textPadding, y: yOffset, width: side, height: side))
        iconView.image = image

        let containerWidth = textPadding + (edgePadding ?? textPadding) + side
        let container = UIView(frame: CGRect(x: 0, y: 0, width: containerWidth, height: bounds.height))
        container.addSubview(iconView)
        leftView = container
        leftViewMode = .always
    }
}
