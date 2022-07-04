//
//  ScalingButton.swift
//  QuizPlease
//
//  Created by Владислав on 21.08.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import UIKit

public class ScalingButton: UIButton {
    public var scaleRate: CGFloat = 0.96

    /// Setting this property assigns `tintColor` to `newValue` and calls `setTitleColor(newValue, for: .normal)`
    public override var tintColor: UIColor! {
        get { super.tintColor }
        set {
            super.tintColor = newValue
            setTitleColor(newValue, for: .normal)
        }
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
    }

    private func configure() {
        let highlightControlEvents: UIControl.Event = [
            .touchDown,
            .touchDragEnter,
            .touchDragInside
        ]
        self.addTarget(self, action: #selector(highlighted), for: highlightControlEvents)

        let releaseControlEvents: UIControl.Event = [
            .touchCancel,
            .touchDragExit,
            .touchUpOutside,
            .touchDragOutside,
            .touchUpInside
        ]
        self.addTarget(self, action: #selector(released), for: releaseControlEvents)
    }

    @objc
    private func highlighted() {
        scaleIn(scale: scaleRate)
    }

    @objc
    private func released() {
        scaleOut()
    }
}
