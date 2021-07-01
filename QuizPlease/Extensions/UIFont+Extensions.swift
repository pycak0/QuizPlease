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
}

public extension FontStyle {
    var fileName: String { "\(Self.self)-\(rawValue)" }
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
        UIFont(name: style.fileName, size: size)!
    }
    
    class func gilroy(_ style: FontSet.Gilroy, size: CGFloat) -> UIFont {
        UIFont(name: style.fileName, size: size)!
    }
}
