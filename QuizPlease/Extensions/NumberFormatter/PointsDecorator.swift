//
//  PointsDecorator.swift
//  QuizPlease
//
//  Created by Владислав on 24.06.2021.
//  Copyright © 2021 Владислав. All rights reserved.
//

import Foundation

class PointsDecorator: NumberDecorator {
    override func string(from number: NSNumber) -> String? {
        let number = number.doubleValue
        if number.truncatingRemainder(dividingBy: 1) == 0 {
            return Int(number).string(withAssociatedMaleWord: "балл")
        }
        let formatted = super.string(from: number as NSNumber) ?? "N/A"
        return "\(formatted) баллов"
    }
    
    override func number(from string: String) -> NSNumber? {
        guard let numberComponent = string.components(separatedBy: " ").first else { return nil }
        return super.number(from: numberComponent)
    }
}
