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

    /// Represents an individual radio button option within a custom field.
    /// Used for fields of type `.radio`.
    struct RadioButton: Decodable {
        /// Option identifier
        let id: Int
        /// Parent field identifier
        let gameFieldId: Int
        /// Displayed option text
        let optionText: String

        private enum CodingKeys: String, CodingKey {
            case id
            case gameFieldId = "game_field_id"
            case optionText = "option_text"
        }
    }

    /// Identifier
    let id: Int
    /// Field title
    let title: String
    /// Placeholder for types `text` and `textarea`
    let placeholder: String
    /// Custom field type
    let type: CustomFieldType
    /// Is field required to be filled in
    let isRequired: Bool
    /// Possible values for `radio` type of field
    let radios: [RadioButton]

    private enum CodingKeys: String, CodingKey {
        case id, title, placeholder, type, radios, isRequired = "is_required"
    }
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

enum CustomFieldType: Int, Codable {
    case text = 0
    case textarea
    case radio
}
