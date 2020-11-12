//
//  WarmupAnswerButton.swift
//  QuizPlease
//
//  Created by Владислав on 12.11.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import UIKit

class WarmupAnswerButton: UIButton {
    
    convenience init(title: String) {
        self.init()
        configure()
        setTitle(title, for: .normal)
    }
    
    func highlightAnswer(isCorrect: Bool) {
        let color: UIColor = isCorrect ? .lightGreen : .red
        backgroundColor = color
        if !isCorrect {
            shakeAnimation()
        }
    }
    
    private func configure() {
        layer.cornerRadius = 20
        titleLabel?.textColor = .white
        titleLabel?.font = UIFont(name: "Gilroy-Bold", size: 22)
        titleLabel?.adjustsFontSizeToFitWidth = true
        backgroundColor = UIColor.white.withAlphaComponent(0.1)
    }

}
