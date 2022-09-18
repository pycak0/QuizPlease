//
//  BigButton.swift
//  QuizPlease
//
//  Created by Владислав on 12.09.2022.
//  Copyright © 2022 Владислав. All rights reserved.
//

import UIKit

public final class BigButton: ScalingButton {

    public override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    private func commonInit() {
        titleLabel?.font = .gilroy(.bold, size: 20)
        layer.cornerRadius = 20
    }

    public override var intrinsicContentSize: CGSize {
        CGSize(width: UIView.noIntrinsicMetric, height: 60)
    }
}
