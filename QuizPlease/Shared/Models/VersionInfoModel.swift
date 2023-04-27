//
//  VersionInfoModel.swift
//  QuizPlease
//
//  Created by Владислав on 28.04.2023.
//  Copyright © 2023 Владислав. All rights reserved.
//

import Foundation

struct VersionInfoModel: Codable {

    let isNewVersionAvailable: Bool
    let forceUpdate: Bool
    let appStoreUrl: URL

    init(data: VersionData, appStoreUrl: URL) {
        isNewVersionAvailable = data.forceUpdate == 1 || data.preferablyUpdate == 1
        forceUpdate = data.forceUpdate == 1
        self.appStoreUrl = appStoreUrl
    }
}
