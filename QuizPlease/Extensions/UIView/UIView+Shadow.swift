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
    func dropShadow() {
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.12
        layer.shadowRadius = 4
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.masksToBounds = false
    }
}
