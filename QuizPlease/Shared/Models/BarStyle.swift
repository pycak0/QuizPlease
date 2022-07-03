//
//  BarStyle.swift
//  QuizPlease
//
//  Created by Владислав on 04.10.2021.
//  Copyright © 2021 Владислав. All rights reserved.
//

import UIKit

enum BarStyle {
    case transparent
    case transcluent(tintColor: UIColor?)
    case opaque(tintColor: UIColor?)

    var tintColor: UIColor? {
        switch self {
        case .transparent:
            return nil
        case .transcluent(let tintColor):
            return tintColor
        case .opaque(let tintColor):
            return tintColor
        }
    }

    @available(iOS 13, *)
    var appearance: UINavigationBarAppearance {
        let appearance = UINavigationBarAppearance()
        switch self {
        case .transparent:
            appearance.configureWithTransparentBackground()
        case .transcluent(let tintColor):
            appearance.configureWithDefaultBackground()
            appearance.backgroundColor = tintColor
        case .opaque(let tintColor):
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = tintColor
        }
        appearance.shadowColor = .clear
        appearance.setBackIndicatorImage(.backButton, transitionMaskImage: .backButton)
        return appearance
    }
}
