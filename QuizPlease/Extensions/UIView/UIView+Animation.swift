//
//  UIView+Animation.swift
//  QuizPlease
//
//  Created by Владислав on 08.10.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import UIKit

extension UIView {
    func shakeAnimation(duration: Double = 0.4, dampingRatio: Double = 0.2, completion: (() -> Void)? = nil) {
        self.transform = CGAffineTransform(translationX: 30, y: 0)
        UIView.animate(
            withDuration: 0.4,
            delay: 0,
            usingSpringWithDamping: 0.2,
            initialSpringVelocity: 10,
            options: []
        ) {
            self.transform = .identity
        } completion: { _ in
            completion?()
        }
    }
}
