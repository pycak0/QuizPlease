//
//  GamePageRegisterFormProvider.swift
//  QuizPlease
//
//  Created by Владислав on 14.04.2023.
//  Copyright © 2023 Владислав. All rights reserved.
//

import Foundation

/// RegisterForm provider protocol
protocol GamePageRegisterFormProvider {

    /// Provides a reference to the shared register form
    func getRegisterForm() -> RegisterForm

    /// Provides a custom fields array with editable user input properties
    func getCustomFields() -> [CustomFieldModel]
}
