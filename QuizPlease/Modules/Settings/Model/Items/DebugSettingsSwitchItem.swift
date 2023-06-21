//
//  DebugSettingsSwitchItem.swift
//  QuizPlease
//
//  Created by Владислав on 21.04.2023.
//  Copyright © 2023 Владислав. All rights reserved.
//

import Foundation

struct DebugSettingsSwitchItem {
    let title: String
    let isEnabledProvider: () -> Bool
    let onValueChange: ((Bool) -> Void)?

    init(
        title: String,
        isEnabledProvider: @autoclosure @escaping () -> Bool,
        onValueChange: ((Bool) -> Void)?
    ) {
        self.title = title
        self.isEnabledProvider = isEnabledProvider
        self.onValueChange = onValueChange
    }
}
