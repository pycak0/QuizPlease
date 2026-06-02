//
//  WepPageBrowserOptions.swift
//  QuizPlease
//
//  Created by Владислав on 13.04.2023.
//  Copyright © 2023 Владислав. All rights reserved.
//

import UIKit

/// Defines where web page should be opened.
enum WebPageOpeningMode {
    case inAppBrowser
    case externalBrowser
}

/// Options to open url in browser
struct WepPageBrowserOptions {

    /// Browser opening mode
    let openingMode: WebPageOpeningMode
    /// Open in reader view automatically (works only for in-app Safari)
    let autoReaderView: Bool
    /// Browser bars color
    let barsColor: UIColor
    /// Browser buttons tint color
    let controlsColor: UIColor
    /// Modal presentation style
    let presentationStyle: UIModalPresentationStyle

    /// Creates an instance of `WepPageBrowserOptions`
    /// - Parameters:
    ///   - openingMode: Browser opening mode
    ///   - autoReaderView: Open in reader view automatically (works only for Safari)
    ///   - barsColor: Browser bars color
    ///   - controlsColor: Browser buttons tint color
    init(
        openingMode: WebPageOpeningMode = .inAppBrowser,
        autoReaderView: Bool = false,
        barsColor: UIColor = .purple,
        controlsColor: UIColor = .white,
        presentationStyle: UIModalPresentationStyle = .automatic
    ) {
        self.openingMode = openingMode
        self.autoReaderView = autoReaderView
        self.barsColor = barsColor
        self.controlsColor = controlsColor
        self.presentationStyle = presentationStyle
    }
}

extension WepPageBrowserOptions {

    /// Options with `autoReaderView` property enabled
    static let autoReaderView: WepPageBrowserOptions = {
        WepPageBrowserOptions(autoReaderView: true)
    }()

    /// Options to open url in external default browser
    static let externalBrowser: WepPageBrowserOptions = {
        WepPageBrowserOptions(openingMode: .externalBrowser)
    }()
}
