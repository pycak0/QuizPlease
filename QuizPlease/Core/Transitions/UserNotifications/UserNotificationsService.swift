//
//  UserNotificationsService.swift
//  QuizPlease
//
//  Created by Владислав on 26.11.2022.
//  Copyright © 2022 Владислав. All rights reserved.
//

import Foundation

/// User Notifications Constants
enum UserNotifications {

    /// Firebase message id key
    static let gcmMessageIDKey = "gcm.message_id"
}

/// Service that handles user notifications
protocol UserNotificationsService {

    /// Handle user notification
    /// - Parameter userInfo: User Info dictionary containing notification data
    /// - Returns: Boolean value indicating whether notification was handled (`true`) or not (`false`)
    @discardableResult
    func handle(userInfo: [AnyHashable: Any]) -> Bool
}

/// Class that implements service that handles user notifications
final class UserNotificationsServiceImpl: UserNotificationsService {

    private let deeplinkService: DeeplinkService
    private let applinkRouter: ApplinkRouter

    /// UserNotificationsService initializer
    /// - Parameters:
    ///   - deeplinkService: Service that handles deeplinks and universal links
    ///   - applinkRouter: Object that manages routing with Applinks
    init(
        deeplinkService: DeeplinkService,
        applinkRouter: ApplinkRouter
    ) {
        self.deeplinkService = deeplinkService
        self.applinkRouter = applinkRouter
    }

    func handle(userInfo: [AnyHashable: Any]) -> Bool {
        // Print message ID.
        if let messageID = userInfo[UserNotifications.gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }

        // 1. Check for deeplinks
        let deeplink = ["deeplink", "link", "url"]
            .compactMap { userInfo[$0] }
            .first as? String

        if let deeplink, let url = URL(string: deeplink) {
            if deeplinkService.handle(url: url) {
                return true
            }
            applinkRouter.prepareTransition(with: .init(
                identifier: "",
                parameters: [:],
                originalUrl: url
            ))
        }

        // 2. Manually check for other endpoints

        // 2.1 GamePageEndpoint
        let gameId = ["game", "gameId", "id"]
            .compactMap { userInfo[$0] }
            .first as? String

        if let gameId {
            applinkRouter.prepareTransition(with: Applink(
                identifier: GamePageEndpoint.identifier,
                parameters: ["gameId": gameId],
                originalUrl: nil
            ))
            return true
        }

        // 3. Return false if all other cases failed to handle
        return false
    }
}
