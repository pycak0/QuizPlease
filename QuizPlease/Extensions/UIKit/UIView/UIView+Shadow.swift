//
//  UIView+Shadow.swift
//  QuizPlease
//
//  Created by Владислав on 20.09.2022.
//  Copyright © 2022 Владислав. All rights reserved.
//

import UIKit

extension UIView {

    /// Add a simple shadow to the view
    func dropShadow(
        radius: CGFloat = 4,
        offset: CGSize = CGSize(width: 0, height: 2),
        color: UIColor = .black,
        opacity: CGFloat = 0.12
    ) {
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = 0.12
        layer.shadowRadius = radius
        layer.shadowOffset = offset
        layer.masksToBounds = false
    }
}
