//
//  Bundle+version.swift
//  QuizPlease
//
//  Created by Владислав on 24.12.2021.
//  Copyright © 2021 Владислав. All rights reserved.
//

import Foundation

extension Bundle {
    
    /// The version of the framework / executable including build number in format '`1.2.3 (54)`'
    var version: String {
        let versionString = object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "unknown"
        let buildNumber = object(forInfoDictionaryKey: "CFBundleVersion") as? String ?? "none"
        return "\(versionString) (\(buildNumber))"
    }
}
