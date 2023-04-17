//
//  GamePagePaymentInfoProvider.swift
//  QuizPlease
//
//  Created by Владислав on 18.04.2023.
//  Copyright © 2023 Владислав. All rights reserved.
//

import Foundation

/// GamePage payment info provider
protocol GamePagePaymentInfoProvider: AnyObject {

    /// Get available payment type names
    func getAvailablePaymentTypeNames() -> [String]

    /// Get currently selected payment type
    func getSelectedPaymentTypeName() -> String

    /// Select new payment type by name 
    func setPaymentType(_ name: String)
}
