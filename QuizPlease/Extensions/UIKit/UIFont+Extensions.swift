//
//  UIFont+Extensions.swift
//  QuizPlease
//
//  Created by Владислав on 19.05.2021.
//  Copyright © 2021 Владислав. All rights reserved.
//

import UIKit

public protocol FontStyle: RawRepresentable {
    var fileName: String { get }
    func font(size: CGFloat) -> UIFont
}

public extension FontStyle {
    var fileName: String { "\(Self.self)-\(rawValue)" }
    func font(size: CGFloat) -> UIFont { UIFont(name: fileName, size: size)! }
}

public enum FontSet {
    public enum Gilroy: String, FontStyle {
        case semibold = "SemiBold"
        case medium = "Medium"
        case bold = "Bold"
        case heavy = "Heavy"
    }
}

public extension UIFont {
    class func customFont<Font: FontStyle>(of style: Font, size: CGFloat) -> UIFont {
        style.font(size: size)
    }

    class func gilroy(_ style: FontSet.Gilroy, size: CGFloat) -> UIFont {
        customFont(of: style, size: size)
    }
}
