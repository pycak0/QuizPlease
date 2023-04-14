//
//  GamePagePresenter.swift
//  QuizPlease
//
//  Created by Владислав on 10.04.2023.
//  Copyright © 2023 Владислав. All rights reserved.
//

import Foundation

/// GamePage presenter
final class GamePagePresenter {

    weak var view: GamePageViewInput?

    // MARK: - Private Properties

    private let itemFactory: GamePageItemFactoryProtocol
    private let interactor: GamePageInteractorProtocol
    private let router: GamePageRouterProtocol

    /// `GamePagePresenter` initializer
    /// - Parameters:
    ///   - itemFactory: Factory that creates GamePage items
    ///   - interactor: GamePage interactor
    ///   - router: GamePage screen router
    init(
        itemFactory: GamePageItemFactoryProtocol,
        interactor: GamePageInteractorProtocol,
        router: GamePageRouterProtocol
    ) {
        self.itemFactory = itemFactory
        self.interactor = interactor
        self.router = router
    }
}

// MARK: - GamePageViewOutput

extension GamePagePresenter: GamePageViewOutput,
                             GamePageRegisterButtonOutput,
                             GamePageInfoOutput {

    func viewDidLoad() {
        view?.startLoading()
        interactor.loadGame { [weak self] error in
            guard let self else { return }
            self.view?.stopLoading()
            if let error {
                self.view?.showAlert(error) {
                    self.router.close()
                }
                return
            }
            self.setGameInfo()
        }
    }

    private func setGameInfo() {
        view?.setTitle(interactor.getGameTitle())
        view?.setItems(itemFactory.makeItems())
        view?.setHeaderImage(path: interactor.getHeaderImagePath())
    }

    // MARK: - GamePageRegisterButtonOutput

    func didPressRegisterButton() {
        print("pressed!")
    }

    // MARK: - GamePageInfoOutput

    func didTapOnMap() {
        router.showMap(for: interactor.getPlaceInfo())
    }
}
