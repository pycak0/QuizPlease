//
//  DebugSettingsSection.swift
//  QuizPlease
//
//  Created by Владислав on 21.04.2023.
//  Copyright © 2023 Владислав. All rights reserved.
//

import Foundation

enum DebugSettingsSection {
    case info([DebugSettingsInfoItem])
    case settings([DebugSettingsSwitchItem])

    var title: String {
        switch self {
        case .info:
            return "Информация о сборке"
        case .settings:
            return "Настройки базовых функций"
        }
    }

    var count: Int {
        switch self {
        case .info(let array):
            return array.count
        case .settings(let array):
            return array.count
        }
    }
}
