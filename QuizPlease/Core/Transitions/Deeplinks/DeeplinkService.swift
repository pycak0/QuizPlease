//
//  DeeplinkService.swift
//  QuizPlease
//
//  Created by Владислав on 01.10.2022.
//  Copyright © 2022 Владислав. All rights reserved.
//

import Foundation

/// Service that handles deeplinks and universal links
protocol DeeplinkService {

    /// Try to handle given URL link.
    /// - Parameter url: URL of deeplink or univeresal link.
    /// - Returns: `true`, if could parse and open the link. Otherwise, returns `false`.
    func handle(url: URL) -> Bool
}

/// Class that implements service that handles deeplinks and universal links
final class DeeplinkServiceImpl: DeeplinkService {

    // MARK: - Private Properties

    private let deeplinkParser: DeeplinkParser
    private let applinkRouter: ApplinkRouter

    // MARK: - Lifecycle

    /// Initializer
    /// - Parameters:
    ///   - deeplinkParser: Service that parses URL (deeplink or universal link) to DeeplinkKind
    ///   - applinkRouter: Object that manages routing with Applinks
    init(
        deeplinkParser: DeeplinkParser,
        applinkRouter: ApplinkRouter
    ) {
        self.deeplinkParser = deeplinkParser
        self.applinkRouter = applinkRouter
    }

    // MARK: - DeeplinkService

    func handle(url: URL) -> Bool {
        guard let deeplink = deeplinkParser.parse(url: url) else {
            return false
        }

        applinkRouter.prepareTransition(with: deeplink)
        return true
    }
}
