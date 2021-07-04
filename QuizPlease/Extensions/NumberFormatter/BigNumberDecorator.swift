//
//  BigNumberDecorator.swift
//  QuizPlease
//
//  Created by Владислав on 22.06.2021.
//  Copyright © 2021 Владислав. All rights reserved.
//

import Foundation

class BigNumberDecorator: NumberDecorator {
    private let suffixLabels: [Character] = "BMK".map { $0 }
    
    override func string(from number: NSNumber) -> String? {
        var number = Double(truncating: number)
        var suffix = ""
        switch number {
        case 1e9...:
            number /= 1e9
            suffix = "B"
        case 1e6...:
            number /= 1e6
            suffix = "M"
        case 1e3...:
            number /= 1e3
            suffix = "K"
        default:
            break
        }
        if let string = super.string(from: number as NSNumber) {
            return string + suffix
        }
        return nil
    }
    
    override func number(from string: String) -> NSNumber? {
        var string = string.trimmingCharacters(in: .whitespacesAndNewlines)
        guard
            let symbol = string.last,
            suffixLabels.contains(symbol) else {
            return super.number(from: string)
        }
        string.removeLast()
        guard var number = super.number(from: string)?.doubleValue else { return nil }
        switch symbol {
        case "B":
            number *= 1e9
        case "M":
            number *= 1e6
        case "K":
            number *= 1e3
        default:
            break
        }
        return number as NSNumber
    }
}
