//
//  UIView+Gradient.swift
//  QuizPlease
//
//  Created by Владислав on 19.05.2021.
//  Copyright © 2021 Владислав. All rights reserved.
//

import UIKit

public extension UIView {

    // MARK: - • With Custom Transform
    /// Deletes existing view background color and makes a gradient one.
    /// This implementation is useful when working with auto-generated gradients
    func addGradient(
        firstColor: UIColor,
        secondColor: UIColor,
        transform: CGAffineTransform = CGAffineTransform(a: 0, b: 1, c: -1, d: 0, tx: 1, ty: 0),
        insertAt pos: UInt32? = 0
    ) {
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

        if pos != nil {
            layer.insertSublayer(gradLayer, at: pos!)
        } else {
            layer.addSublayer(gradLayer)
        }
    }

    // MARK: - • With UIColor Array
    /// Supports array of colors and setting optional start, end points and the gradient layer frame
    /// - Parameters:
    ///   - frame: An optional frame for the gradient layer. Default is `view`'s `bounds`
    ///   - startPoint: Read description of `CAGradientLayer`'s `startPoint`
    ///   - endPoint: Read description of `CAGradientLayer`'s `endPoint`
    ///   - pos: A position to insert gradient layer at. The default is `0`,
    ///   i.e. adding it as the bottom view's layer. If `nil`, adds as the top view layer
    @discardableResult
    func addGradient(
        colors: [UIColor],
        startPoint: CGPoint? = nil,
        endPoint: CGPoint? = nil,
        frame: CGRect? = nil,
        insertAt pos: UInt32? = 0
    ) -> CAGradientLayer {
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

        return gradLayer
    }

    // MARK: - • With Preset
    /// - parameter pos: A position to insert gradient layer at. The default is `0`,
    /// i.e. adding it as the bottom view's layer. If `nil`, adds as the top view layer
    @discardableResult
    func addGradient(_ preset: GradientPreset, insertAt pos: UInt32? = 0) -> CAGradientLayer {
        return addGradient(colors: preset.colors, insertAt: pos)
    }

    enum GradientPreset {
        case warmupItems, turquoise, lemonOrange, rose, azure

        var colors: [UIColor] {
            switch self {
            case .warmupItems:
                return [
                    UIColor(red: 0.392, green: 0.161, blue: 0.686, alpha: 1),
                    UIColor(red: 0.387, green: 0.315, blue: 0.921, alpha: 1)
                ]
            case .turquoise:
                return [.turquoise, .bluishGreen]
            case .lemonOrange:
                return [.lemon, .lightOrange]
            case .rose:
                return [.systemPink, .roseRed]
            case .azure:
                return [.skyAzure, .citySky]
            }
        }

        static var shopItemPresets: [GradientPreset] {
            return [.turquoise, lemonOrange, .warmupItems, .rose, .azure]
        }
    }
}
