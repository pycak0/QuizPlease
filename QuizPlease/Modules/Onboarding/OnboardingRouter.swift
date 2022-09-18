//
//  OnboardingRouter.swift
//  QuizPlease
//
//  Created by Владислав on 14.09.2022.
//  Copyright © 2022 Владислав. All rights reserved.
//

import UIKit

/// Onboarding router
protocol OnboardingRouterProtocol {

    /// Close onboarding screen
    func close()
}

/// Onboarding router implementation
final class OnboardingRouter: OnboardingRouterProtocol {

    weak var viewController: UIViewController?
    weak var delegate: OnboardingScreenDelegate?

    func close() {
        DispatchQueue.main.async { [viewController] in
            viewController?.dismiss(animated: true) {
                self.delegate?.onboardingDidClose()
            }
        }
    }
}
