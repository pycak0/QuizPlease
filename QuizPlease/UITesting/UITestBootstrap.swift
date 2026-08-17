//
//  UITestBootstrap.swift
//  QuizPlease
//
//  Created by Codex on 09.07.2026.
//  Copyright © 2026 Владислав. All rights reserved.
//

#if DEBUG

import UIKit

enum UITestBootstrap {

    private static let scenarios: [UITestBootstrapScenario.Type] = [
        UITestRatingBootstrap.self,
        UITestGamePageBootstrap.self
    ]

    static var isEnabled: Bool {
        scenarios.contains { $0.isEnabled }
    }

    @available(iOS 13.0, *)
    static func presentIfNeeded(in scene: UIScene) -> Bool {
        scenarios.contains { $0.presentIfNeeded(in: scene) }
    }
}

protocol UITestBootstrapScenario {
    static var isEnabled: Bool { get }

    @available(iOS 13.0, *)
    static func presentIfNeeded(in scene: UIScene) -> Bool
}

#endif
