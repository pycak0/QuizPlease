//
//  TitleLabel.swift
//  QuizPlease
//
//  Created by Владислав on 08.08.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import UIKit

class TitleLabel: UILabel {

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    convenience init(title: String, textColor: UIColor? = nil, textAlignment: NSTextAlignment = .left) {
        self.init()
        frame = CGRect(x: 0, y: 0, width: 1000, height: 22)
        font = .gilroy(.bold, size: 24)
        self.textAlignment = textAlignment
        text = title
        if let color = textColor {
            self.textColor = color
        }
        adjustsFontSizeToFitWidth = true
    }
}
