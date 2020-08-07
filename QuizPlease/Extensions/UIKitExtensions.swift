//
//  UIKitExtensions.swift
//  QuizPlease
//
//  Created by Владислав on 31.07.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import UIKit

public extension UIView {
    func scaleIn(scale: CGFloat = 0.96) {
        UIView.animate(withDuration: 0.1) {
            self.transform = CGAffineTransform(scaleX: scale, y: scale)
        }
    }
    
    func scaleOut() {
        UIView.animate(withDuration: 0.1) {
            self.transform = .identity
        }
    }
}


public extension UIColor {
    class var darkBlue: UIColor {
        return UIColor(named: "darkBlue")!
    }
    
    class var olive: UIColor {
        return UIColor(named: "olive")!
    }
}
