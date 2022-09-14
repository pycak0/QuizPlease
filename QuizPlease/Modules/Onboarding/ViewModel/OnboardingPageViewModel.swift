//
//  OnboardingPageViewModel.swift
//  QuizPlease
//
//  Created by Владислав on 13.09.2022.
//  Copyright © 2022 Владислав. All rights reserved.
//

import UIKit

struct OnboardingPageViewModel {

    let image: UIImage?
    let title: String
    let subtitle: String

    init(data: OnboardingData) {
        self.image = UIImage(named: data.image)
        self.title = data.title
        self.subtitle = data.subtitle
    }
}
