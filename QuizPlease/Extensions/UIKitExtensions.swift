//
//  UIKitExtensions.swift
//  QuizPlease
//
//  Created by Владислав on 31.07.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import UIKit

public extension UIView {
    //MARK:- View Scale Animation
    func scaleIn(scale: CGFloat = 0.96) {
        UIView.animate(withDuration: 0.15) {
            self.transform = CGAffineTransform(scaleX: scale, y: scale)
        }
    }
    
    func scaleOut() {
        UIView.animate(withDuration: 0.15) {
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

//MARK:- UITextField
public extension UITextField{
   @IBInspectable var placeholderColor: UIColor? {
        get {
            return self.attributedPlaceholder?.attribute(.foregroundColor, at: 0, effectiveRange: nil) as? UIColor
        }
        set {
            self.attributedPlaceholder = NSAttributedString(
                string: self.placeholder ?? "",
                attributes: [NSAttributedString.Key.foregroundColor : newValue!])
        }
    }
    
    ///- parameter side: Preferred width and height of image's `CGrect` (the shape is a square). Is set to `frame.height` value if bigger than it
    ///- parameter textPadding: Image inset from textField's text
    ///- parameter edgePadding: Image inset from textField's left side. The default is equal to `textPadding` value
    func setImage(_ image: UIImage?, side: CGFloat = 20, textPadding: CGFloat = 16, edgePadding: CGFloat? = nil) {
        let side = min(side, bounds.height)
        let yOffset = (bounds.height - side) / 2
        let iconView = UIImageView(frame: CGRect(x: edgePadding ?? textPadding, y: yOffset, width: side, height: side))
        iconView.image = UIImage(named: "search")
        
        let containerWidth = textPadding + (edgePadding ?? textPadding) + side
        let container = UIView(frame: CGRect(x: 0, y: 0, width: containerWidth, height: bounds.height))
        container.addSubview(iconView)
        leftView = container
        leftViewMode = .always
    }
}

//MARK:- CGRect
extension CGRect {
    ///retunrs a new CGRect with changed `height`
    mutating func setHeight(_ height: CGFloat) {
        self = CGRect(origin: self.origin, size: CGSize(width: self.width, height: height))
    }
}


//MARK:- Colors
public extension UIColor {
    class var darkBlue: UIColor {
        return UIColor(named: "darkBlue")!
    }
    
    ///dark blue with kind of purple
    class var plum: UIColor {
        UIColor(named: "plum")!
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
    
    class var lightGreen: UIColor {
        return UIColor(named: "lightGreen")!
    }
    
    class var themeGray: UIColor {
        UIColor(named: "themeGray")!
    }
    
    class var labelAdapted: UIColor {
        if #available(iOS 13.0, *) {
            return .label
        }
        return .black
    }

}
