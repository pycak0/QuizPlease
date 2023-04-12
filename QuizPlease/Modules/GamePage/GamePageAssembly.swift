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

    private let services: ServiceAssembly = ServiceAssembly.shared
    private let gameInfo: GameInfo

    init(gameInfo: GameInfo) {
        self.gameInfo = gameInfo
    }
}

// MARK: - ViewAssembly

extension GamePageAssembly: ViewAssembly {

    func makeViewController() -> UIViewController {
        let interactor = GamePageInteractor(
            gameInfo: gameInfo,
            placeAnnotationProvider: services.placeAnnotationProvider
        )
        let annotationBuilder = GamePageAnnotationBuilder(annotationProvider: interactor)
        let registerButtonBuilder = GamePageRegisterButtonBuilder(gameStatusProvider: interactor)
        let infoBuilder = GamePageInfoBuilder(placeProvider: interactor)
        let itemFactory = GamePageItemFactory(
            annotationBuilder: annotationBuilder,
            registerButtonBuilder: registerButtonBuilder,
            infoBuilder: infoBuilder
        )
        let presenter = GamePagePresenter(
            itemFactory: itemFactory,
            interactor: interactor
        )
        let viewController = GamePageViewController(output: presenter)

        registerButtonBuilder.output = presenter
        presenter.view = viewController

        return viewController
    }
}
