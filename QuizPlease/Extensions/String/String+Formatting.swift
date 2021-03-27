//
//  String+Formatting.swift
//  QuizPlease
//
//  Created by Владислав on 14.10.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import Foundation

extension String {
    ///Ensures that string has a "/" prefix and removes percent encoding
    var pathProof: String {
        var res = self
        if !self.hasPrefix("/") {
            res = "/" + self
        }
        return res.removingPercentEncoding ?? res
    }
    
    ///Deletes angle brackets and all content inside them
    func deletingAngleBrackets() -> String {
        return self
            .replacingOccurrences(of: "\\<[^\\>]+\\>",
                                  with: "",
                                  options: .regularExpression)
            .trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
