//
//  NumberFormatter+DecimalStyle.swift
//  QuizPlease
//
//  Created by Владислав on 18.06.2021.
//  Copyright © 2021 Владислав. All rights reserved.
//

import Foundation

extension NumberFormatter {
    /// Formats given number in such way that it displays from 0 to 2 fraction digits
    /// in decimal style and uses "`,`" decimal separator. Does not use number groups
    public static let decimalFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 0
        formatter.numberStyle = .decimal
        formatter.decimalSeparator = ","
        formatter.usesGroupingSeparator = false
        return formatter
    }()

    /// Formats given number like usual `decimalFormatter` but also uses number groups
    public static var decimalGroupingFormatter: NumberFormatter {
        let formatter = decimalFormatter
        formatter.usesGroupingSeparator = true
        formatter.groupingSeparator = " "
        return formatter
    }
}
