//
//  CGRect+setHeight.swift
//  QuizPlease
//
//  Created by Владислав on 19.05.2021.
//  Copyright © 2021 Владислав. All rights reserved.
//

import CoreGraphics

extension CGRect {
    /// retunrs a new CGRect with changed `height`
    mutating func setHeight(_ height: CGFloat) {
        self = CGRect(origin: self.origin, size: CGSize(width: self.width, height: height))
    }
}
