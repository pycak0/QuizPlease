//
//  AppDelegate.swift
//  QuizPlease
//
//  Created by Владислав on 30.07.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import Firebase
import UserNotificationsUI
import PhoneNumberKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, MessagingDelegate {

    private let transitionFacade = CoreAssembly.shared.transitionFacade

    var window: UIWindow?

    // MARK: - Application Lifecycle
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {

        FirebaseApp.configure()
        Messaging.messaging().delegate = self

        UNUserNotificationCenter.current().delegate = self

        application.registerForRemoteNotifications()

        UIBarButtonItem.swizzleMenu()
        IQKeyboardManager.shared.keyboardDistanceFromTextField = 20
        IQKeyboardManager.shared.enable = true
        PhoneNumberKit.CountryCodePicker.forceModalPresentation = true
        PhoneNumberKit.CountryCodePicker.commonCountryCodes = []

        return transitionFacade.handleLaunchOptions(launchOptions)
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        Utilities.main.updateToken()
    }

    // MARK: UISceneSession Lifecycle

    @available(iOS 13.0, *)
    func application(
        _ application: UIApplication,
        configurationForConnecting connectingSceneSession: UISceneSession,
        options: UIScene.ConnectionOptions
    ) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    @available(iOS 13.0, *)
    func application(
        _ application: UIApplication,
        didDiscardSceneSessions sceneSessions: Set<UISceneSession>
    ) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running,
        // this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    // MARK: - Did Receieve FCM Token

    func messaging(
        _ messaging: Messaging,
        didReceiveRegistrationToken fcmToken: String?
    ) {
        print("Registration Token: \(fcmToken ?? "NONE")")
        guard let fcmToken = fcmToken else { return }

        #if !targetEnvironment(simulator)
        NetworkService.shared.sendFirebaseId(fcmToken)
        DefaultsManager.shared.saveFcmToken(fcmToken)
        #endif
    }

    func application(
        _ app: UIApplication,
        open url: URL,
        options: [UIApplication.OpenURLOptionsKey: Any]
    ) -> Bool {
        transitionFacade.handleOpenUrl(url, options: options)
    }

    func application(
        _ application: UIApplication,
        continue userActivity: NSUserActivity,
        restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void
    ) -> Bool {
        transitionFacade.continueUserActivity(userActivity)
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {

    // MARK: - Did Receive Remote Notification
    func application(
        _ application: UIApplication,
        didReceiveRemoteNotification userInfo: [AnyHashable: Any]
    ) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.

        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)

        // Print message ID.
        if let messageID = userInfo[UserNotifications.gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }

        // Print full message.
        print(userInfo)
    }

    // MARK: - Did Receive Remote Notification with Completion Handler
    func application(
        _ application: UIApplication,
        didReceiveRemoteNotification userInfo: [AnyHashable: Any],
        fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void
    ) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.

        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)

        // Print message ID.
        if let messageID = userInfo[UserNotifications.gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }

        // Print full message.
        print(userInfo)

        completionHandler(UIBackgroundFetchResult.newData)
    }

    // MARK: Will Present Notification
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {

        let userInfo = notification.request.content.userInfo

        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        // Print message ID.
        if let messageID = userInfo[UserNotifications.gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }

        // Print full message.
        print(userInfo)

        // Change this to your preferred presentation option
        completionHandler([.alert, .badge, .sound])
    }

    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        let userInfo = response.notification.request.content.userInfo
        transitionFacade.handleUserNotification(info: userInfo)
        completionHandler()
    }
}
