//
//  OnboardingPageData.swift
//  QuizPlease
//
//  Created by Владислав on 14.09.2022.
//  Copyright © 2022 Владислав. All rights reserved.
//

import Foundation

/// Decodable onboarding page data
struct OnboardingPageData: Decodable {

    /// Title
    let title: String
    /// Subtitle
    let subtitle: String
    /// Name of the image that is located in the app's bundle
    let image: String
}
