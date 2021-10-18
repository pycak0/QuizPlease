//
//  UIKitExtensions.swift
//  QuizPlease
//
//  Created by Владислав on 31.07.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import UIKit

// MARK: - UIView
///

public extension UIView {
    
    @IBInspectable
    var cornerRadiusView: CGFloat {
        get { self.layer.cornerRadius }
        set { self.layer.cornerRadius = newValue }
    }
    
    @IBInspectable
    var borderWidthView: CGFloat {
        get { self.layer.borderWidth }
        set { self.layer.borderWidth = newValue }
    }
    
    @IBInspectable
    var borderColorView: UIColor? {
        get {
            if let color = self.layer.borderColor {
                return UIColor(cgColor: color)
            } else {
                return nil
            }
        }
        set { self.layer.borderColor = newValue?.cgColor }
    }
    
    // MARK: - View Scale Animation
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
    
    // MARK: - Add Blur to View
    ///Clears view's background color by default but you can specify blur background color
    @discardableResult
    func addBlur(color: UIColor = .clear, style: UIBlurEffect.Style = .regular, alpha: CGFloat = 1) -> UIVisualEffectView {
        let blur = UIVisualEffectView(effect: UIBlurEffect(style: style))
        blur.frame = self.bounds
        blur.alpha = alpha
        blur.isUserInteractionEnabled = false
        blur.clipsToBounds = true
        blur.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blur.backgroundColor = color
        self.backgroundColor = .clear

        //self.addSubview(blur)
        self.insertSubview(blur, at: 0)
        return blur
    }
    
    // MARK: - Draw Dotted Line
    @discardableResult
    static func drawDottedLine(
        in view: UIView,
        start: CGPoint,
        end: CGPoint,
        dashLength: Double = 7,
        gapLength: Double = 3
    ) -> CAShapeLayer {
        let shapeLayer = CAShapeLayer()
        shapeLayer.strokeColor = UIColor.lightGray.cgColor
        shapeLayer.lineWidth = 1
        shapeLayer.lineDashPattern = [dashLength, gapLength] as [NSNumber] // [length of dash, length of gap]

        let path = CGMutablePath()
        path.addLines(between: [start, end])
        shapeLayer.path = path
        view.layer.addSublayer(shapeLayer)
        
        return shapeLayer
    }
}
