//
//  NotificationService.swift
//  QuizPlease
//
//  Created by Русаков Владислав Андреевич on 27.12.2025.
//  Copyright © 2025 Владислав. All rights reserved.
//

import UIKit
import UserNotifications

protocol NotificationService {

    func requestForPushNotifications()
}

final class NotificationServiceImpl: NotificationService {

    private let notificationCenter: UNUserNotificationCenter
    private let mainExecutor: AsyncExecutor
    private let log: Logger

    init(
        notificationCenter: UNUserNotificationCenter = .current(),
        mainExecutor: AsyncExecutor,
        log: Logger
    ) {
        self.notificationCenter = notificationCenter
        self.mainExecutor = mainExecutor
        self.log = log
    }

    func requestForPushNotifications() {
        notificationCenter.requestAuthorization(options: [.alert, .sound, .criticalAlert]) { [unowned self] granted, _ in
            guard granted else { return }
            mainExecutor.async { [log] in
                log.info("Initiating registration process with Apple Push Notification service")
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }
}
