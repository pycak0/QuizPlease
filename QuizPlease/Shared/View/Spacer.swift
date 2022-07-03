//
//  Spacer.swift
//  QuizPlease
//
//  Created by Владислав on 09.11.2021.
//  Copyright © 2021 Владислав. All rights reserved.
//

import UIKit

class Spacer: UIView {

    init() {
        super.init(frame: .zero)
        sharedInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        sharedInit()
    }

    private func sharedInit() {
        setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        setContentHuggingPriority(.defaultLow, for: .horizontal)
        setContentHuggingPriority(.defaultLow, for: .vertical)
    }
}
