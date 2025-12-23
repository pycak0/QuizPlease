//
//  CustomFieldOutputData.swift
//  QuizPlease
//
//  Created by Владислав on 22.05.2023.
//  Copyright © 2023 Владислав. All rights reserved.
//

import Foundation

/// Custom field output data that is sent to the backend
struct CustomFieldOutputData: Encodable {

    let fieldId: Int
    /// Value that was filled in by the user
    let value: String?

    /// Initialize `CustomFieldOutputData` with model
    init(model: CustomFieldModel) {
        self.fieldId = model.data.id
        self.value = model.inputValue
    }
}
