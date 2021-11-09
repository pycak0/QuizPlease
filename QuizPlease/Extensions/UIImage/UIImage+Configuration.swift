//
//  UIImage+Configuration.swift
//  QuizPlease
//
//  Created by Владислав on 09.11.2021.
//  Copyright © 2021 Владислав. All rights reserved.
//

import UIKit

extension UIImage {
    
    /// Works only for SF Symbols, iOS 13+ (`@available` attribute wasn't added for convenience).
    /// In iOS 12 will return the image as it is
    func withPointSize(_ points: CGFloat) -> UIImage? {
        if #available(iOS 13.0, *) {
            let configuration = SymbolConfiguration(pointSize: points)
            return self.withConfiguration(configuration)
        } else {
            return self
        }
    }
    
    /// Works only for SF Symbols, iOS 13+ (`@available` attribute wasn't added for convenience).
    /// In iOS 12 will return the image as it is
    func withScale(_ scale: SFSymbolScale) -> UIImage? {
        if #available(iOS 13.0, *) {
            let configuration = SymbolConfiguration(scale: scale.symbolScale)
            return self.withConfiguration(configuration)
        } else {
            return self
        }
    }
    
    /// Mapper for `SymbolScale`
    enum SFSymbolScale {
        case small, medium, large, `default`, unspecified
        
        @available(iOS 13.0, *)
        fileprivate var symbolScale: SymbolScale {
            switch self {
            case .small:
                return .small
            case .medium:
                return .medium
            case .large:
                return .large
            case .unspecified:
                return .unspecified
            case .`default`:
                return .`default`
            }
        }
    }
}

