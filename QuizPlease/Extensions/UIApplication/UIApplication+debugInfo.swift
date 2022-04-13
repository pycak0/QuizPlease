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
        let appVersionString = Bundle.main.version
        let buildKind = AppSettings.isDebug ? "Debug" : "Release"
        return """
        AppVersion: \(buildKind) \(appVersionString)
        \(AppSettings.description)
        \(NetworkConfiguration.standard)
        """
    }
}
