//
//  SplashScreenPresenter.swift
//  QuizPlease
//
//  Created by Владислав on 12.04.2021.
//  Copyright © 2021 Владислав. All rights reserved.
//

import Foundation

// MARK: - Presenter Protocol
protocol SplashScreenPresenterProtocol {
    var router: SplashScreenRouterProtocol { get }
    init(view: SplashScreenViewProtocol, interactor: SplashScreenInteractorProtocol, router: SplashScreenRouterProtocol)

    func viewDidLoad(_ view: SplashScreenViewProtocol)
}

class SplashScreenPresenter: SplashScreenPresenterProtocol {
    weak var view: SplashScreenViewProtocol?
    var interactor: SplashScreenInteractorProtocol
    var router: SplashScreenRouterProtocol

    private let dispatchGroup = DispatchGroup()

    private let timeout = 0.5

    required init(
        view: SplashScreenViewProtocol,
        interactor: SplashScreenInteractorProtocol,
        router: SplashScreenRouterProtocol
    ) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }

    func viewDidLoad(_ view: SplashScreenViewProtocol) {
        updateUserToken()
        setTimer()
        dispatchGroup.notify(queue: .main) {
            self.router.showMainMenu()
        }
    }

    private func updateUserToken() {
        dispatchGroup.enter()
        interactor.updateUserToken()
    }

    private func setTimer() {
        dispatchGroup.enter()
        Timer.scheduledTimer(withTimeInterval: timeout, repeats: false) { [self] _ in
            dispatchGroup.leave()
            view?.startLoading()
        }
    }
}

// MARK: - SplashScreenInteractorOutput
extension SplashScreenPresenter: SplashScreenInteractorOutput {
    func interactorDidUpdateUserToken(_ interactor: SplashScreenInteractorProtocol) {
        interactor.updateDefaultCity()
        interactor.updateClientSettings()
    }

    func interactor(_ interactor: SplashScreenInteractorProtocol, errorOccured error: NetworkServiceError) {
        dispatchGroup.leave()
        print(error)
    }

    func interactor(_ interactor: SplashScreenInteractorProtocol, didLoadClientSettings settings: ClientSettings) {
        dispatchGroup.leave()
    }
}
