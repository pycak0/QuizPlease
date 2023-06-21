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
        let appVersionString = Bundle.main.versionAndBuild
        return """
        AppVersion: \(Configuration.current) \(appVersionString)
        \(AppSettings.description)
        \(NetworkConfiguration.standard)
        """
    }
}
