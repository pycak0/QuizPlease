//
//  DataTypesExtensions.swift
//  QuizPlease
//
//  Created by Владислав on 31.07.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import Foundation

extension Int {
    ///Returns a string containing number and a word changed to match the number. This method works for male words from Russian language and changes them according to the rules of language.
    ///In Russian: метод изменяет заднное слово мужского рода по падежам, чтобы оно подходило к заданному числу.
    ///
    ///- parameter word: Associated male russian word, must be given in singular form (Именительный Падеж, единственное число)
    ///
    ///`5.string(withAssociatedMaleWord: "балл") -> "5 баллов"`
    
    func string(withAssociatedMaleWord word: String) -> String {
        let result = "\(self) \(word)"
        if self % 10 == 1 && self % 100 != 11 {
            return result
        }
        if 2 <= self % 10 && self % 10 <= 4 && (self % 100 > 20 || self % 100 < 10) {
            return result + "a"
        }
        return result + "ов"
    }
}
