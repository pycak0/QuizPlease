//
//  UIView+Bounce.swift
//  QuizPlease
//
//  Created by Владислав on 04.11.2022.
//  Copyright © 2022 Владислав. All rights reserved.
//

import UIKit

extension UIView {

    /// Perform bounce animation
    func bounce() {
        let targetScale: CGFloat = 1.1
        let startScale = self.transform
        UIView.animate(withDuration: 0.2) {
            self.transform = startScale.scaledBy(x: targetScale, y: targetScale)
        } completion: { _ in
            UIView.animate(withDuration: 0.1) {
                self.transform = startScale
            }
        }
    }
}
