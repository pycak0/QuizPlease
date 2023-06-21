//
//  CustomFieldModel.swift
//  QuizPlease
//
//  Created by Владислав on 14.04.2023.
//  Copyright © 2023 Владислав. All rights reserved.
//

import Foundation

/// Model that stores information of custom field and the user's input
final class CustomFieldModel {

    /// Data of custom field in Game info
    let data: CustomFieldData
    /// The value that user has selected or typed
    var inputValue: String?

    init(data: CustomFieldData, inputValue: String? = nil) {
        self.data = data
        self.inputValue = inputValue
    }
}
