//
//  UIView+Shake.swift
//  QuizPlease
//
//  Created by Владислав on 08.10.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import UIKit

extension UIView {

    /// Shake view horizontally with animation
    func shake(duration: Double = 0.5, dampingRatio: Double = 0.2, completion: (() -> Void)? = nil) {
        self.transform = CGAffineTransform(translationX: 30, y: 0)
        UIView.animate(
            withDuration: duration,
            delay: 0,
            usingSpringWithDamping: dampingRatio,
            initialSpringVelocity: 0,
            options: []
        ) {
            self.transform = .identity
        } completion: { _ in
            completion?()
        }
    }
}
