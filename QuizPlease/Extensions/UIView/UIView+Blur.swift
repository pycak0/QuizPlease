//
//  UIView+Blur.swift
//  QuizPlease
//
//  Created by Владислав on 28.08.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import UIKit

extension UIView {

    private struct AssociatedKeys {
        static var descriptiveName = "AssociatedKeys.DescriptiveName.blurView"
    }

    private (set) var blurView: BlurView {
        get {
            if let blurView = objc_getAssociatedObject(
                self,
                &AssociatedKeys.descriptiveName
                ) as? BlurView {
                return blurView
            }
            self.blurView = BlurView(to: self)
            return self.blurView
        }
        set(blurView) {
            objc_setAssociatedObject(
                self,
                &AssociatedKeys.descriptiveName,
                blurView,
                .OBJC_ASSOCIATION_RETAIN_NONATOMIC
            )
        }
    }

    class BlurView {

        private var superview: UIView
        private var blur: UIVisualEffectView?
        private var editing: Bool = false
        private (set) var blurContentView: UIView?
        private (set) var vibrancyContentView: UIView?

        var animationDuration: TimeInterval = 0.1

        /**
         * Blur style. After it is changed all subviews on
         * blurContentView & vibrancyContentView will be deleted.
         */
        var style: UIBlurEffect.Style = .light {
            didSet {
                guard oldValue != style,
                    !editing else { return }
                applyBlurEffect()
            }
        }
        /**
         * Alpha component of view. It can be changed freely.
         */
        var alpha: CGFloat = 0 {
            didSet {
                guard !editing else { return }
                if blur == nil {
                    applyBlurEffect()
                }
                let alpha = self.alpha
                UIView.animate(withDuration: animationDuration) {
                    self.blur?.alpha = alpha
                }
            }
        }

        /// Make sure that color's alpha component is not greater than 0.5. Otherwise, blur won't have much effect.
        var backgroundColor: UIColor? {
            didSet {
                blur?.backgroundColor = backgroundColor
            }
        }

        init(to view: UIView) {
            self.superview = view
        }

        func setup(style: UIBlurEffect.Style, alpha: CGFloat) -> Self {
            self.editing = true

            self.style = style
            self.alpha = alpha

            self.editing = false

            return self
        }

        /// Blur preset made especially for bottom popup screens
        ///
        /// - parameter color: Blur background color. Color's `alpha` is set automatically to the value of `0.4`
        func setupPopupBlur(_ color: UIColor = .middleBlue) {
            setup(style: .regular, alpha: 1).enable()
            backgroundColor = color.withAlphaComponent(0.4)
        }

        func enable(isHidden: Bool = false) {
            if blur == nil {
                applyBlurEffect()
            }

            self.blur?.isHidden = isHidden
        }

        private func applyBlurEffect() {
            blur?.removeFromSuperview()

            applyBlurEffect(
                style: style,
                blurAlpha: alpha
            )
        }

        private func applyBlurEffect(style: UIBlurEffect.Style,
                                     blurAlpha: CGFloat) {
            superview.backgroundColor = UIColor.clear

            let blurEffect = UIBlurEffect(style: style)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)

            let vibrancyEffect = UIVibrancyEffect(blurEffect: blurEffect)
            let vibrancyView = UIVisualEffectView(effect: vibrancyEffect)
            blurEffectView.contentView.addSubview(vibrancyView)

            blurEffectView.alpha = blurAlpha

            superview.insertSubview(blurEffectView, at: 0)

            blurEffectView.addAlignedConstrains()
            vibrancyView.addAlignedConstrains()

            self.blur = blurEffectView
            self.blurContentView = blurEffectView.contentView
            self.vibrancyContentView = vibrancyView.contentView
        }
    }

    private func addAlignedConstrains() {
        translatesAutoresizingMaskIntoConstraints = false
        addAlignConstraintToSuperview(attribute: NSLayoutConstraint.Attribute.top)
        addAlignConstraintToSuperview(attribute: NSLayoutConstraint.Attribute.leading)
        addAlignConstraintToSuperview(attribute: NSLayoutConstraint.Attribute.trailing)
        addAlignConstraintToSuperview(attribute: NSLayoutConstraint.Attribute.bottom)
    }

    private func addAlignConstraintToSuperview(attribute: NSLayoutConstraint.Attribute) {
        superview?.addConstraint(
            NSLayoutConstraint(
                item: self,
                attribute: attribute,
                relatedBy: NSLayoutConstraint.Relation.equal,
                toItem: superview,
                attribute: attribute,
                multiplier: 1,
                constant: 0
            )
        )
    }
}
