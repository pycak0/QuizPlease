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
    func removingAngleBrackets(replaceWith replaceString: String = "") -> String {
        return self
            .replacingOccurrences(of: "\\<[^\\>]+\\>",
                                  with: replaceString,
                                  options: .regularExpression)
            .trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    ///Be careful when using this method because some HTML attributes may be parsed slowly
    func htmlFormatted() -> NSMutableAttributedString? {
        guard let htmlData = self
                .trimmingCharacters(in: .whitespacesAndNewlines)
                .data(using: .unicode) else { return nil }
        
        return try? NSMutableAttributedString(data: htmlData,
                                              options: [.documentType : NSAttributedString.DocumentType.html],
                                              documentAttributes: nil)
    }
}
