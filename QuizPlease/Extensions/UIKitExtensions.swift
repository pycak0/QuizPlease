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
    
    //MARK:- Add Gradient to any UIView
    ///Deletes existing view background color and makes a gradient one. This implementation is useful when working with auto-generated gradients
    func addGradient(firstColor: UIColor,
                     secondColor: UIColor,
                     transform: CGAffineTransform = CGAffineTransform(a: 0, b: 1, c: -1, d: 0, tx: 1, ty: 0)) {
        self.backgroundColor = .white

        let gradLayer = CAGradientLayer()

        gradLayer.colors = [
          firstColor.cgColor,
          secondColor.cgColor
        ]

        gradLayer.locations = [0, 1]
        gradLayer.startPoint = CGPoint(x: 0.25, y: 0.5)
        gradLayer.endPoint = CGPoint(x: 0.75, y: 0.5)

        gradLayer.transform = CATransform3DMakeAffineTransform(transform)

        gradLayer.bounds = self.bounds.insetBy(dx: -0.5 * self.bounds.size.width, dy: -0.5 * self.bounds.size.height)
        gradLayer.position = self.center

        self.layer.addSublayer(gradLayer)
    }
    
    ///Supports array of colors and setting optional start, end points and the gradient layer frame
    ///- parameter frame: An optional frame for the gradient layer. Default is `view`'s `bounds`
    ///- parameter startPoint: Read description of `CAGradientLayer`'s `startPoint`
    ///- parameter endPoint: Read description of `CAGradientLayer`'s `endPoint`
    ///- parameter pos: A position to insert gradient layer at. The default is adding it as the top view's layer
    func addGradient(colors: [UIColor], startPoint: CGPoint? = nil, endPoint: CGPoint? = nil, frame: CGRect? = nil, insertAt pos: UInt32? = nil) {
        self.backgroundColor = .clear
        
        let gradLayer = CAGradientLayer()
        gradLayer.colors = colors.map { $0.cgColor }
        
        if startPoint != nil { gradLayer.startPoint = startPoint! }
        if endPoint != nil { gradLayer.endPoint = endPoint! }
        
        gradLayer.frame = frame ?? self.bounds
        
        if pos != nil {
            self.layer.insertSublayer(gradLayer, at: pos!)
        } else {
            self.layer.addSublayer(gradLayer)
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
    
    class var lemon: UIColor {
        return UIColor(named: "lemon")!
    }
    
    class var lightOrange: UIColor {
        return UIColor(named: "lightOrange")!
    }
}
