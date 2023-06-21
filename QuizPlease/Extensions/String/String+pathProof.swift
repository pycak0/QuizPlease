//
//  String+pathProof.swift
//  QuizPlease
//
//  Created by Владислав on 20.04.2023.
//  Copyright © 2023 Владислав. All rights reserved.
//

import Foundation

extension String {

    /// Ensures that string has a "/" prefix and removes percent encoding
    var pathProof: String {
        var res = self
        if !self.hasPrefix("/") {
            res = "/" + self
        }
        return res.removingPercentEncoding ?? res
    }
}
