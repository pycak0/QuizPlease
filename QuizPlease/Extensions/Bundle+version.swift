//
//  Bundle+version.swift
//  QuizPlease
//
//  Created by Владислав on 24.12.2021.
//  Copyright © 2021 Владислав. All rights reserved.
//

import Foundation

extension Bundle {

    static let shortVersionKey: String = "CFBundleShortVersionString"
    static let buildNumberKey: String = "CFBundleVersion"

    /// The version of the framework / executable including build number in format '`1.2.3 (54)`'
    var versionAndBuild: String {
        let versionString = object(forInfoDictionaryKey: Bundle.shortVersionKey) as? String ?? "unknown"
        let buildNumber = object(forInfoDictionaryKey: Bundle.buildNumberKey) as? String ?? "none"
        return "\(versionString) (\(buildNumber))"
    }

    /// The version of the framework / executable in format '`1.2.3`'
    var shortVersion: String {
        return object(forInfoDictionaryKey: Bundle.shortVersionKey) as? String ?? ""
    }
}
