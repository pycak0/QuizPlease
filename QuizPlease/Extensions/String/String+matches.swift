//
//  String+matches.swift
//  QuizPlease
//
//  Created by Владислав on 20.04.2023.
//  Copyright © 2023 Владислав. All rights reserved.
//

import Foundation

extension String {

    /// Returns an array containing all the matches of the regular expression in the string.
    func matches(of regex: String) -> [[String]] {
        let nsString = self as NSString
        return (try? NSRegularExpression(pattern: regex, options: []))?
            .matches(in: self, options: [], range: NSRange(location: 0, length: nsString.length))
            .map { match in
                (0..<match.numberOfRanges).map {
                    match.range(at: $0).location == NSNotFound
                    ? ""
                    : nsString.substring(with: match.range(at: $0))
                }
            } ?? []
    }
}
