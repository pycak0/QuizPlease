//
//  UIApplication+debugInfo.swift
//  QuizPlease
//
//  Created by Владислав on 11.08.2021.
//  Copyright © 2021 Владислав. All rights reserved.
//

import UIKit

extension UIApplication {
    var debugInfo: String {
        let appVersionString: String = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
        let buildNumber: String = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as! String
        let buildKind = AppSettings.isDebug ? "Debug" : "Release"
        return """
        AppVersion: \(buildKind) \(appVersionString) (\(buildNumber))
        \(AppSettings.description)
        \(NetworkConfiguration.standard)
        """
    }
}
