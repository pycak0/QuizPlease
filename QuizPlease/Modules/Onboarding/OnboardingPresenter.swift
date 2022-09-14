//
//  OnboardingPresenter.swift
//  QuizPlease
//
//  Created by Владислав on 14.09.2022.
//  Copyright © 2022 Владислав. All rights reserved.
//

import Foundation

final class OnboardingPresenter {

    weak var view: OnboardingViewProtocol?

    private let interactor: OnboardingInteractorProtocol
    private let router: OnboardingRouterProtocol

    init(
        interactor: OnboardingInteractorProtocol,
        router: OnboardingRouterProtocol
    ) {
        self.interactor = interactor
        self.router = router
    }

    private func close() {
        router.close()
    }
}

// MARK: - OnboardingViewOutput

extension OnboardingPresenter: OnboardingViewOutput {

    func viewDidLoad() {
        interactor.getOnboardingItems { [weak self] items in
            guard let self = self else { return }
            let pages = items.map { OnboardingPageViewModel(data: $0) }
            self.view?.set(pages: pages)
        }
    }

    func skipButtonPressed() {
        close()
    }

    func doneButtonPressed() {
        close()
    }
}
