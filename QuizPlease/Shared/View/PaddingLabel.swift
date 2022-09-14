//
//  PaddingLabel.swift
//  QuizPlease
//
//  Created by Владислав on 22.06.2021.
//  Copyright © 2021 Владислав. All rights reserved.
//

import UIKit

@IBDesignable
final class PaddingLabel: UILabel {

    @IBInspectable var topInset: CGFloat = 0
    @IBInspectable var bottomInset: CGFloat = 0
    @IBInspectable var leftInset: CGFloat = 10
    @IBInspectable var rightInset: CGFloat = 10

    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(
            top: topInset,
            left: leftInset,
            bottom: bottomInset,
            right: rightInset
        )
        super.drawText(in: rect.inset(by: insets))
    }

    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(
            width: size.width + leftInset + rightInset,
            height: size.height + topInset + bottomInset
        )
    }

    override var bounds: CGRect {
        didSet {
            preferredMaxLayoutWidth = bounds.width - (leftInset + rightInset)
        }
    }
}
