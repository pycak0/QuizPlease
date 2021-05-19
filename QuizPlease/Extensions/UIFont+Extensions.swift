//
//  UIFont+Extensions.swift
//  QuizPlease
//
//  Created by Владислав on 19.05.2021.
//  Copyright © 2021 Владислав. All rights reserved.
//

import UIKit

public enum GilroyFontStyle: String {
    case semibold = "SemiBold"
    case medium = "Medium"
    case bold = "Bold"
    case heavy = "Heavy"
    
    fileprivate var fileName: String { "Gilroy-\(rawValue)" }
}

public extension UIFont {
    class func gilroy(_ style: GilroyFontStyle, size: CGFloat) -> UIFont {
        UIFont(name: style.fileName, size: size)!
    }
}
