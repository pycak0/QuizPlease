//
//  UIColor+Static.swift
//  QuizPlease
//
//  Created by Владислав on 18.08.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import UIKit

// MARK: - Colors
public extension UIColor {
    class var darkBlue: UIColor {
        return UIColor(named: "darkBlue")!
    }

    /// In the light appearance, it's the same color as `darkBlue`.
    /// In the dark appearance, becomes `white`.
    class var darkBlueDynamic: UIColor {
        UIColor(named: "darkBlueDynamic")!
    }

    class var middleBlue: UIColor {
        UIColor(named: "middleBlue")!
    }

    /// Dark blue with kind of purple - Цвет спелой сливы
    class var ripePlum: UIColor {
        UIColor(named: "ripePlum")!
    }

    /// Purple with pink - Сливовый цвет
    class var plum: UIColor {
        UIColor(named: "plum")!
    }

    class var olive: UIColor {
        UIColor(named: "olive")!
    }

    class var lemon: UIColor {
        UIColor(named: "lemon")!
    }

    class var lightOrange: UIColor {
        UIColor(named: "lightOrange")!
    }

    class var lightGreen: UIColor {
        UIColor(named: "lightGreen")!
    }

    class var themeGray: UIColor {
        UIColor(named: "themeGray")!
    }

    /// Бирюзовый
    class var turquoise: UIColor {
        UIColor(named: "turquoise")!
    }

    /// Синевато-зеленый
    class var bluishGreen: UIColor {
        UIColor(named: "bluishGreen")!
    }

    class var roseRed: UIColor {
        UIColor(named: "roseRed")!
    }

    class var citySky: UIColor {
        UIColor(named: "citySky")!
    }

    class var skyAzure: UIColor {
        UIColor(named: "skyAzure")!
    }

    class var themePurple: UIColor {
        UIColor(named: "themePurple")!
    }

    class var themePink: UIColor {
        UIColor(named: "themePink")!
    }

    /// For iOS 13+, returns `label`.
    /// For iOS 12, returns `black`
    class var labelAdapted: UIColor {
        if #available(iOS 13.0, *) {
            return .label
        }
        return .black
    }

    /// For iOS 13+, returns `systemBackground`.
    /// For iOS 12, returns `white`
    class var systemBackgroundAdapted: UIColor {
        if #available(iOS 13.0, *) {
            return .systemBackground
        }
        return .white
    }

    /// For iOS 13+, returns `secondarySystemBackground`.
    /// For iOS 12, returns `systemBackgroundAdapted`
    class var secondarySystemBackgroundAdapted: UIColor {
        if #available(iOS 13.0, *) {
            return .secondarySystemBackground
        }
        return .systemBackgroundAdapted
    }

    class var systemGray6Adapted: UIColor {
        if #available(iOS 13.0, *) {
            return .systemGray6
        }
        return .themeGray
    }

    class var systemGray5Adapted: UIColor {
        if #available(iOS 13.0, *) {
            return .systemGray5
        }
        return .lightGray
    }

    class var opaqueSeparatorAdapted: UIColor {
        if #available(iOS 13.0, *) {
            return .opaqueSeparator
        } else {
            return UIColor.lightGray.withAlphaComponent(0.7)
        }
    }
}
