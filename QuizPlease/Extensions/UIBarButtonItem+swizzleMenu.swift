//
//  UIBarButtonItem+swizzleMenu.swift
//  QuizPlease
//
//  Created by Владислав on 30.01.2022.
//  Copyright © 2022 Владислав. All rights reserved.
//

import UIKit

extension UIBarButtonItem {
    
    /// Remove back button navigation menu (iOS 14+) with method swizzling
    static func swizzleMenu() {
        guard #available(iOS 14, *) else { return }
        exchange(
            #selector(setter: UIBarButtonItem.menu),
            with: #selector(setter: UIBarButtonItem.swizzledMenu)
        )
    }
    
    @available(iOS 14, *)
    @objc dynamic private var swizzledMenu: UIMenu? {
        get {
            nil
        }
        set {
            // nothing
        }
    }
    
    private static func exchange(
        _ selector1: Selector,
        with selector2: Selector
    ) {
        guard
            let method = class_getInstanceMethod(Self.self, selector1),
            let swizzled = class_getInstanceMethod(Self.self, selector2)
        else {
            return
        }
        method_exchangeImplementations(method, swizzled)
    }
}
