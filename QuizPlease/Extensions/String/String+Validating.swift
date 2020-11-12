//
//  String+Validating.swift
//  QuizPlease
//
//  Created by Владислав on 12.11.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import Foundation

extension String {
    //MARK:- Mobile Phone
    ///A phone string may have only '`+`' sign and whole digits to pass the validating and must be 11 or 12 characters length (depending on the existence of `+` sign)
    var isValidMobilePhone: Bool {
        var str = self
        if str.hasPrefix("+") {
            str.remove(at: str.startIndex)
        }
        if str.count != 11 {
            return false
        }
        
        return str.allSatisfy { $0.isWholeNumber }
    }
    
    //MARK:- Is Valid Email
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
