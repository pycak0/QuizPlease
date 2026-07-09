//
//  UITestLaunchArguments.swift
//  QuizPlease
//
//  Created by Codex on 07.07.2026.
//  Copyright © 2026 Владислав. All rights reserved.
//

#if DEBUG

import Foundation

enum UITestLaunchArgument: String {
    case gamePageMaxParticipants = "-UITestGamePageMaxParticipants"
    case ratingSeason = "-UITestRatingSeason"
}

enum UITestLaunchArguments {

    static func contains(_ argument: UITestLaunchArgument) -> Bool {
        ProcessInfo.processInfo.arguments.contains(argument.rawValue)
    }
}

#endif
