//
//  GamePageAssembly.swift
//  QuizPlease
//
//  Created by Владислав on 10.04.2023.
//  Copyright © 2023 Владислав. All rights reserved.
//

import UIKit

/// GamePage screen assembly
final class GamePageAssembly {

    private let gameInfo: GameInfo

    init(gameInfo: GameInfo) {
        self.gameInfo = gameInfo
    }
}

// MARK: - ViewAssembly

extension GamePageAssembly: ViewAssembly {

    func makeViewController() -> UIViewController {
        let itemFactory = GamePageItemFactory()
        let interactor = GamePageInteractor(gameInfo: gameInfo)
        let presenter = GamePagePresenter(
            itemFactory: itemFactory,
            interactor: interactor
        )
        let viewController = GamePageViewController(output: presenter)

        presenter.view = viewController

        return viewController
    }
}
