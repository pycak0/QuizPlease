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

    private let interactor: GamePageInteractorProtocol
    private let itemFactory: GamePageItemFactoryProtocol

    /// `GamePagePresenter` initializer
    /// - Parameters:
    ///   - itemFactory: Factory that creates GamePage items
    ///   - interactor: GamePage interactor
    init(
        itemFactory: GamePageItemFactoryProtocol,
        interactor: GamePageInteractorProtocol
    ) {
        self.itemFactory = itemFactory
        self.interactor = interactor
    }
}

// MARK: - GamePageViewOutput

extension GamePagePresenter: GamePageViewOutput {

    func viewDidLoad() {
        view?.setTitle(interactor.getGameTitle())
        view?.setItems(itemFactory.makeItems())
        view?.setHeaderImage(path: "/")
    }
}
