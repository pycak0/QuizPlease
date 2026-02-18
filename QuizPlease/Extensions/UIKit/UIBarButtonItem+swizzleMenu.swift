//
//  UIBarButtonItem+swizzleMenu.swift
//  QuizPlease
//
//  Created by Владислав on 30.01.2022.
//  Copyright © 2022 Владислав. All rights reserved.
//

import UIKit
import ObjectiveC

extension UIBarButtonItem {
    private static var menuEnabledAssociationKey: UInt8 = 0

    @available(iOS 14.0, *)
    var isMenuEnabled: Bool {
        get {
            (objc_getAssociatedObject(self, &Self.menuEnabledAssociationKey) as? Bool) == true
        }
        set {
            objc_setAssociatedObject(
                self,
                &Self.menuEnabledAssociationKey,
                newValue,
                .OBJC_ASSOCIATION_RETAIN_NONATOMIC
            )
        }
    }

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
            guard isMenuEnabled else { return nil }
            return swizzledMenu
        }
        // swiftlint:disable:next unused_setter_value
        set {
            if isMenuEnabled {
                swizzledMenu = newValue
            } else {
                swizzledMenu = nil
            }
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
