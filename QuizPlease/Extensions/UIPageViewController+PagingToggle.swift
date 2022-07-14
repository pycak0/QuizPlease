//
//  UIPageViewController+PagingToggle.swift
//  mvd
//
//  Created by Владислав on 17.09.2020.
//  Copyright © 2020 AMG-BS. All rights reserved.
//

import UIKit

extension UIPageViewController {
    var isPagingEnabled: Bool {
        get {
            var isEnabled: Bool = true
            for view in view.subviews {
                if let subView = view as? UIScrollView {
                    isEnabled = subView.isScrollEnabled
                }
            }
            return isEnabled
        }
        set {
            for view in view.subviews {
                if let subView = view as? UIScrollView {
                    subView.isScrollEnabled = newValue
                }
            }
        }
    }
}
