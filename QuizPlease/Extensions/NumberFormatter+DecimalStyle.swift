//
//  NumberFormatter+DecimalStyle.swift
//  QuizPlease
//
//  Created by Владислав on 18.06.2021.
//  Copyright © 2021 Владислав. All rights reserved.
//

import Foundation

extension NumberFormatter {
    static let decimalFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 0
        formatter.numberStyle = .decimal
        formatter.decimalSeparator = ","
        return formatter
    }()
}
