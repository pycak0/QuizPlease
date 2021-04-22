//
//  UIRefreshControl+Init.swift
//  QuizPlease
//
//  Created by Владислав on 22.04.2021.
//  Copyright © 2021 Владислав. All rights reserved.
//

import UIKit

extension UIRefreshControl {
    convenience init(tintColor: UIColor = .lightGray, target: Any?, action: Selector) {
        self.init()
        self.tintColor = tintColor
        addTarget(target, action: action, for: .valueChanged)
    }
}
