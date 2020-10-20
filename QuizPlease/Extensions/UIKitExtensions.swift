//
//  UIKitExtensions.swift
//  QuizPlease
//
//  Created by Владислав on 31.07.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import UIKit

//MARK:- UIView
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
    
    
    ///
    //MARK:- • With Custom Transform
    ///Deletes existing view background color and makes a gradient one. This implementation is useful when working with auto-generated gradients
    func addGradient(firstColor: UIColor,
                     secondColor: UIColor,
                     transform: CGAffineTransform = CGAffineTransform(a: 0, b: 1, c: -1, d: 0, tx: 1, ty: 0)) {
        self.backgroundColor = .white
        self.clipsToBounds = true

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
    
    //MARK:- • With Colors Array
    ///Supports array of colors and setting optional start, end points and the gradient layer frame
    ///- parameter frame: An optional frame for the gradient layer. Default is `view`'s `bounds`
    ///- parameter startPoint: Read description of `CAGradientLayer`'s `startPoint`
    ///- parameter endPoint: Read description of `CAGradientLayer`'s `endPoint`
    ///- parameter pos: A position to insert gradient layer at. The default is `0`, i.e. adding it as the bottom view's layer. If `nil`, adds as the top view layer
    func addGradient(colors: [UIColor], startPoint: CGPoint? = nil, endPoint: CGPoint? = nil, frame: CGRect? = nil, insertAt pos: UInt32? = 0) {
        self.backgroundColor = .clear
        self.clipsToBounds = true
        
        let gradLayer = CAGradientLayer()
        gradLayer.colors = colors.map { $0.cgColor }
        
        if startPoint != nil { gradLayer.startPoint = startPoint! }
        if endPoint != nil { gradLayer.endPoint = endPoint! }
        
        gradLayer.frame = frame ?? self.bounds
        gradLayer.cornerRadius = self.layer.cornerRadius
        gradLayer.masksToBounds = true
        
        if pos != nil {
            self.layer.insertSublayer(gradLayer, at: pos!)
        } else {
            self.layer.addSublayer(gradLayer)
        }
    }
    
    //MARK:- • With Preset
    ///- parameter pos: A position to insert gradient layer at. The default is `0`, i.e. adding it as the bottom view's layer. If `nil`, adds as the top view layer
    func addGradient(_ preset: GradientPreset, insertAt pos: UInt32? = 0) {
        addGradient(colors: preset.colors, insertAt: pos)
    }
    
    enum GradientPreset {
        case warmupItems
        
        var colors: [UIColor] {
            switch self {
            case .warmupItems:
                return [UIColor(red: 0.392, green: 0.161, blue: 0.686, alpha: 1),
                        UIColor(red: 0.387, green: 0.315, blue: 0.921, alpha: 1)]
            }
        }
    }
    
    
    //MARK:- Add Tap Gesture Recognizer to a View
    fileprivate struct AssociatedObjectKeys {
        static var tapGestureRecognizer = "MediaViewerAssociatedObjectKey_mediaViewer"
    }

    fileprivate typealias Action = (() -> Void)?
    fileprivate var tapGestureRecognizerAction: Action? {
        set {
            if let newValue = newValue {
                // Computed properties get stored as associated objects
                objc_setAssociatedObject(self, &AssociatedObjectKeys.tapGestureRecognizer, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
            }
        }
        get {
            let tapGestureRecognizerActionInstance = objc_getAssociatedObject(self, &AssociatedObjectKeys.tapGestureRecognizer) as? Action
            return tapGestureRecognizerActionInstance
        }
    }
    
    func addTapGestureRecognizer(action: (() -> Void)?) {
        self.isUserInteractionEnabled = true
        self.tapGestureRecognizerAction = action
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture))
        self.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc fileprivate func handleTapGesture(sender: UITapGestureRecognizer) {
        if let action = self.tapGestureRecognizerAction {
            action?()
        } else {
            print("no action")
        }
    }
    
    //MARK:- Add Blur to View
    ///Clears view's background color by default but you can specify blur background color
    func addBlur(color: UIColor = .clear, style: UIBlurEffect.Style = .regular, alpha: CGFloat = 1) {
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
    }
    
    //MARK:- Draw Dotted Line
    static func drawDottedLine(in view: UIView, start p0: CGPoint, end p1: CGPoint, dashLength: NSNumber = 7, gapLength: NSNumber = 3) {
        let shapeLayer = CAShapeLayer()
        shapeLayer.strokeColor = UIColor.lightGray.cgColor
        shapeLayer.lineWidth = 1
        shapeLayer.lineDashPattern = [dashLength, gapLength] // [length of dash, length of gap]

        let path = CGMutablePath()
        path.addLines(between: [p0, p1])
        shapeLayer.path = path
        view.layer.addSublayer(shapeLayer)
    }
    
}

//MARK:- UITextField
///

public extension UITextField{
    //MARK:- Placeholder color
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
    
    
    //MARK:- Set Image
    
    ///- parameter side: Preferred width and height of image's `CGrect` (the shape is a square).
    ///- parameter textPadding: Image inset from textField's text
    ///- parameter edgePadding: Image inset from textField's left side. The default is equal to `textPadding` value
    func setImage(_ image: UIImage?, side: CGFloat = 20, textPadding: CGFloat = 16, edgePadding: CGFloat? = nil) {
        
        let yOffset = (bounds.height - side) / 2
        let iconView = UIImageView(frame: CGRect(x: edgePadding ?? textPadding, y: yOffset, width: side, height: side))
        iconView.image = image
        
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
