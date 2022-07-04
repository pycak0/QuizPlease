//
//  UIView+Blurable.swift
//  QuizPlease
//
//  Created by Владислав on 29.01.2021.
//  Copyright © 2021 Владислав. All rights reserved.
//

import UIKit

private class BlurOverlay: UIImageView {}

private struct BlurableKey {
    static var blurable = "blurable"
}

// MARK: - Blurable Protocol
protocol Blurable {
    var layer: CALayer { get }
    var subviews: [UIView] { get }
    var frame: CGRect { get }
    var superview: UIView? { get }

    func addSubview(_ view: UIView)
    func removeFromSuperview()

    func setBlur(radius: CGFloat)
    func removeBlur()

    var isBlurred: Bool { get }
}

extension UIView: Blurable {}

extension Blurable {
    // MARK: - Is Blurred
    var isBlurred: Bool {
        guard let self = self as? UIView else { return false }
        return objc_getAssociatedObject(self, &BlurableKey.blurable) is BlurOverlay
    }

    // MARK: - Set Blur
    func setBlur(radius: CGFloat) {
        if self.superview == nil {
            return
        }

        UIGraphicsBeginImageContextWithOptions(CGSize(width: frame.width, height: frame.height), false, 1)

        layer.render(in: UIGraphicsGetCurrentContext()!)

        guard let image = UIGraphicsGetImageFromCurrentImageContext() else {
            UIGraphicsEndImageContext()
            return
        }
        UIGraphicsEndImageContext()

        guard let blur = CIFilter(name: "CIGaussianBlur"),
              let this = self as? UIView
        else {
            return
        }

        blur.setValue(CIImage(image: image), forKey: kCIInputImageKey)
        blur.setValue(radius, forKey: kCIInputRadiusKey)

        let ciContext  = CIContext(options: nil)

        guard let result = blur.value(forKey: kCIOutputImageKey) as? CIImage else { return }

        let boundingRect = CGRect(x: 0,
            y: 0,
            width: frame.width,
            height: frame.height)

        guard let cgImage = ciContext.createCGImage(result, from: boundingRect) else { return }

        let filteredImage = UIImage(cgImage: cgImage)

        let blurOverlay = BlurOverlay()
        blurOverlay.frame = boundingRect

        blurOverlay.image = filteredImage
        blurOverlay.contentMode = .left

        if let superview = superview as? UIStackView,
           let index = (superview as UIStackView).arrangedSubviews.firstIndex(of: this) {
            removeFromSuperview()
            superview.insertArrangedSubview(blurOverlay, at: index)
        } else {
            blurOverlay.frame.origin = frame.origin
            UIView.transition(from: this, to: blurOverlay, duration: 0.2, options: .curveEaseIn, completion: nil)
        }

        objc_setAssociatedObject(this, &BlurableKey.blurable, blurOverlay, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
    }

    // MARK: - Remove Blur
    func removeBlur() {
        guard let this = self as? UIView,
              let blurOverlay = objc_getAssociatedObject(this, &BlurableKey.blurable) as? BlurOverlay
        else {
            return
        }

        if let superview = blurOverlay.superview as? UIStackView,
           let index = superview.arrangedSubviews.firstIndex(of: blurOverlay) {
            blurOverlay.removeFromSuperview()
            superview.insertArrangedSubview(this, at: index)
        } else {
            this.frame.origin = blurOverlay.frame.origin
            UIView.transition(from: blurOverlay, to: this, duration: 0.2, options: .curveEaseIn, completion: nil)
        }

        objc_setAssociatedObject(this, &BlurableKey.blurable, nil, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
    }
}
