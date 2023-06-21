//
//  CustomField.swift
//  QuizPlease
//
//  Created by Владислав on 14.04.2023.
//  Copyright © 2023 Владислав. All rights reserved.
//

import Foundation

/// Custom field in Game info
struct CustomFieldData: Decodable {

    /// Field title
    let label: String
    /// Technical identifier
    let name: String
    /// Placeholder for types `text` and `textarea`
    let placeholder: String
    /// Custom field type
    let type: CustomFieldKind
    /// Is field required to be filled in
    let isRequired: Bool
    /// Possible values for `radio` type of field
    let values: [String]
}

/// Describes possible types of `CustomField`
enum CustomFieldKind: String, Codable {
    /// Single-line text
    case text
    /// Multiline text
    case textarea
    /// Single choice question with radiobuttons
    case radio
}
