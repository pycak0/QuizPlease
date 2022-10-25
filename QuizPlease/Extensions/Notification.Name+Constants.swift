//
//  Notification.Name+Constants.swift
//  QuizPlease
//
//  Created by Владислав on 08.10.2022.
//  Copyright © 2022 Владислав. All rights reserved.
//

import Foundation

extension Notification.Name {

    /// Notification that is fired when main screen did load.
    static let mainScreenLoaded = Notification.Name.withId("mainScreenLoaded")

    private static func withId(_ identifier: String) -> Notification.Name {
        let bundleId = Bundle.main.bundleIdentifier ?? ""
        let prefix = "\(bundleId).Notification."
        return Notification.Name("\(prefix).\(identifier)")
    }
}
