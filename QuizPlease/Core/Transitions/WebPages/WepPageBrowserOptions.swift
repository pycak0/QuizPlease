//
//  WepPageBrowserOptions.swift
//  QuizPlease
//
//  Created by Владислав on 13.04.2023.
//  Copyright © 2023 Владислав. All rights reserved.
//

import UIKit

/// Options to open url in browser
struct WepPageBrowserOptions {

    /// Open in reader view automatically (works only for Safari)
    let autoReaderView: Bool
    /// Browser bars color
    let barsColor: UIColor
    /// Browser buttons tint color
    let controlsColor: UIColor

    /// Creates an instance of `WepPageBrowserOptions`
    /// - Parameters:
    ///   - autoReaderView: Open in reader view automatically (works only for Safari)
    ///   - barsColor: Browser bars color
    ///   - controlsColor: Browser buttons tint color
    init(
        autoReaderView: Bool = false,
        barsColor: UIColor = .purple,
        controlsColor: UIColor = .white
    ) {
        self.autoReaderView = autoReaderView
        self.barsColor = barsColor
        self.controlsColor = controlsColor
    }
}
