//
//  NSAttributedString+TrimmingWhitespacesAndNewlines.swift
//  QuizPlease
//
//  Created by Владислав on 14.04.2023.
//  Copyright © 2023 Владислав. All rights reserved.
//

import Foundation

extension NSAttributedString {

    /// Returns an attributed string with trimmed whitespaces and newlines
    /// from the start and the end of the string
    func trimmingWhitespacesAndNewlines() -> NSAttributedString {
        let invertedSet = CharacterSet.whitespacesAndNewlines.inverted
        let startRange = string.utf16.description.rangeOfCharacter(from: invertedSet)
        let endRange = string.utf16.description.rangeOfCharacter(from: invertedSet, options: .backwards)
        guard let startLocation = startRange?.upperBound, let endLocation = endRange?.lowerBound else {
            return NSAttributedString(string: string)
        }

        let location = string.utf16.distance(from: string.startIndex, to: startLocation) - 1
        let length = string.utf16.distance(from: startLocation, to: endLocation) + 2
        let range = NSRange(location: location, length: length)

        return attributedSubstring(from: range)
    }
}
