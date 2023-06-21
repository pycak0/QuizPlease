//
//  ScheduleGameSubscriptionResponse.swift
//  QuizPlease
//
//  Created by Владислав on 17.10.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import Foundation

/// Response on subscription status for a game in Schedule
struct ScheduleGameSubscriptionResponse: Decodable {

    /// Message kind showing the current subscription status
    enum MessageKind: String, Decodable {
        case subscribe, unsubscribe
    }

    /// Response success status
    let success: Bool
    /// Message kind showing the current subscription status
    let message: MessageKind
    /// Alert title
    let title: String?
    /// Alert message
    let text: String?
}
