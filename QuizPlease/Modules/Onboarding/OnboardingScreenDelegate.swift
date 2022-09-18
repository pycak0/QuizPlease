//
//  OnboardingScreenDelegate.swift
//  QuizPlease
//
//  Created by Владислав on 14.09.2022.
//  Copyright © 2022 Владислав. All rights reserved.
//

/// Onboarding screen delegate protocol.
protocol OnboardingScreenDelegate: AnyObject {

    /// Tells the delegate that onboarding screen was closed.
    func onboardingDidClose()
}
