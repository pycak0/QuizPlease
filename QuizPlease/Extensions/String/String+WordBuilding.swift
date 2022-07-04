//
//  String+WordBuilding.swift
//  QuizPlease
//
//  Created by Владислав on 12.07.2021.
//  Copyright © 2021 Владислав. All rights reserved.
//

extension String {
    /// Returns a string containing a word changed to match the number.
    /// This method works for male words from Russian language and changes them according to the rules of language.
    /// In Russian: метод изменяет заднное слово мужского рода по падежам, чтобы оно подходило к заданному числу.
    ///
    /// - parameter number: A number that used to change the `self` in according to it
    ///
    /// `"балл".changingAs(maleWordUsedWithNumber: 5) -> "баллов"`
    ///
    /// - warning: `self` will be treated as an associated male russian word in a singular form
    /// (Именительный Падеж, единственное число)
    func changingAs(maleWordUsedWithNumber number: Int) -> String {
        if number % 10 == 1 && number % 100 != 11 {
            return self
        }
        if 2 <= number % 10 && number % 10 <= 4 && (number % 100 > 20 || number % 100 < 10) {
            return self + "a"
        }
        return self + "ов"
    }

    /// Returns a string containing a word changed to match the number.
    /// This method works for words from Russian language than end with letter "a" (first-case words)
    /// and changes them according to the rules of language.
    /// In Russian: метод добавляет окончание к заданному слово 1-го склонения в указанном падеже,
    /// чтобы оно подходило к заданному числу.
    ///
    /// - Parameters:
    ///   - number: A number that used to change the `self` in according to it
    ///   - changingCase: Падеж
    ///
    /// `"игра".changingAs(firstCaseWordUsedWithNumber: 5, changingCase: .nominative) -> "игр"`
    func changingAs(firstCaseWordUsedWithNumber number: Int, changingCase: ChangingCase) -> String {
        let root = String(self.dropLast())
        if number % 10 == 1 && number % 100 != 11 {
            switch changingCase {
            case .nominative:
                return root + "a"
            case .genitive:
                return root + "у"
            }
        }
        if 2 <= number % 10 && number % 10 <= 4 && (number % 100 > 20 || number % 100 < 10) {
            return root + "ы"
        }
        return root
    }

    /// Падеж
    enum ChangingCase {
        /// Именительный падеж
        case nominative
        /// Родительный падеж
        case genitive
    }
}
