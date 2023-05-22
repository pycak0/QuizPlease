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

    /// Field title
    let label: String
    /// Technical identifier
    let name: String
    /// Custom field type
    let type: CustomFieldKind
    /// Value that was filled in by the user
    let value: String?

    /// Initialize `CustomFieldOutputData` with model
    init(model: CustomFieldModel) {
        self.label = model.data.label
        self.name = model.data.name
        self.type = model.data.type
        self.value = model.inputValue
    }
}
