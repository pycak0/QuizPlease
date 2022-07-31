//
//  String+Validating.swift
//  QuizPlease
//
//  Created by Владислав on 12.11.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import Foundation

extension String {

    // MARK: - Mobile Phone

    /// A phone string may have only '`+`' sign in the start
    /// and contain only whole digits to pass this validating.
    /// Amount of digits is ignored.
    var isValidMobilePhone: Bool {
        var str = self
        if str.hasPrefix("+") {
            str.remove(at: str.startIndex)
        }
        return str.allSatisfy { $0.isWholeNumber }
    }

    // MARK: - Is Valid Email

    var isValidEmail: Bool {
        let list = self.map { String($0) }
        guard let atSymbol = list.firstIndex(of: "@"),
              let dotSymbol = list.lastIndex(of: ".") else {
            return false
        }

        if !(atSymbol > 0 && atSymbol + 1 < dotSymbol) {
            return false
        }
        return true
    }
}
