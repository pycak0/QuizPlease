//
//  OnboardingAssembly.swift
//  QuizPlease
//
//  Created by Владислав on 14.09.2022.
//  Copyright © 2022 Владислав. All rights reserved.
//

import UIKit

final class OnboardingAssembly {

    let core = CoreAssembly.shared

    func makeViewController(delegate: OnboardingScreenDelegate?) -> UIViewController {
        let router = OnboardingRouter()
        let interactor = OnboardingInteractor(
            jsonDecoder: core.jsonDecoder,
            concurrentExecutor: core.concurrentExecutor
        )
        let presenter = OnboardingPresenter(
            interactor: interactor,
            router: router
        )
        let viewController = OnboardingViewController(output: presenter)

        presenter.view = viewController
        router.viewController = viewController
        router.delegate = delegate

        return viewController
    }
}
