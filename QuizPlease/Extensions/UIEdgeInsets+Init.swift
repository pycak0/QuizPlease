//
//  UIEdgeInsets+Init.swift
//  QuizPlease
//
//  Created by Владислав on 19.12.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import UIKit

extension UIEdgeInsets {
    /// All four insets will be equal to the same value provided via this `init`
    init(all insets: CGFloat) {
        self.init(top: insets, left: insets, bottom: insets, right: insets)
    }

    /// Left and right insets will be equal to the `vertical` value, top and bottom - to the `horizontal`
    init(vertical: CGFloat, horizontal: CGFloat) {
        self.init(top: vertical, left: horizontal, bottom: vertical, right: horizontal)
    }
}
