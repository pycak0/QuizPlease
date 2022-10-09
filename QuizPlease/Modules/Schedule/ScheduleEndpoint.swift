//
//  ScheduleEndpoint.swift
//  QuizPlease
//
//  Created by Владислав on 09.10.2022.
//  Copyright © 2022 Владислав. All rights reserved.
//

import UIKit

/// Endpoint class for the Schedule screen
final class ScheduleEndpoint: ApplinkEndpoint {

    // MARK: - ApplinkEndpoint

    static let identifier = "schedule"

    func show(parameters: [String: String]) -> Bool {
        print("📲 Schedule Endpoint entry")
        guard let topNavigationController = UIApplication.shared
            .getKeyWindow()?
            .topNavigationController
        else {
            logFail("Could not find topNavigationController of the App")
            return false
        }

        guard let storyboard = topNavigationController.storyboard else {
            logFail("Could not find storyboard of the topNavigationController")
            return false
        }

        guard let scheduleVC = storyboard.instantiateViewController(
            withIdentifier: "\(ScheduleVC.self)"
        ) as? ScheduleVC else {
            logFail("Could not instantiate view controller from storyboard")
            return false
        }

        topNavigationController.pushViewController(scheduleVC, animated: true)
        print("✅ Successful transition to Schedule Screen")
        return true
    }

    private func logFail(_ message: String) {
        print("❌ Unsuccessful transition: \(message)")
    }
}
