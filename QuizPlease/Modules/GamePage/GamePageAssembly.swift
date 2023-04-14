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
    private let gameId: Int

    init(gameId: Int) {
        self.gameId = gameId
    }
}

// MARK: - ViewAssembly

extension GamePageAssembly: ViewAssembly {

    func makeViewController() -> UIViewController {
        let registrationService = RegistrationService(gameId: gameId)
        let interactor = GamePageInteractor(
            gameId: gameId,
            gameInfoLoader: services.gameInfoLoader,
            placeGeocoder: services.placeGeocoder,
            registrationService: registrationService
        )
        let annotationBuilder = GamePageAnnotationBuilder(annotationProvider: interactor)
        let registerButtonBuilder = GamePageRegisterButtonBuilder(gameStatusProvider: interactor)
        let infoBuilder = GamePageInfoBuilder(infoProvider: interactor)
        let descriptionBuilder = GamePageDescriptionBuilder(descriptionProvider: interactor)
        let basicFieldBuilder = GamePageBasicFieldBuilder(registerFormProvider: interactor)

        let itemFactory = GamePageItemFactory(
            annotationBuilder: annotationBuilder,
            registerButtonBuilder: registerButtonBuilder,
            infoBuilder: infoBuilder,
            descriptionBuilder: descriptionBuilder,
            basicFieldBuilder: basicFieldBuilder
        )
        let router = GamePageRouter()
        let presenter = GamePagePresenter(
            itemFactory: itemFactory,
            interactor: interactor,
            router: router
        )
        let viewController = GamePageViewController(output: presenter)

        infoBuilder.output = presenter
        registerButtonBuilder.output = presenter
        presenter.view = viewController
        router.viewController = viewController

        return viewController
    }
}
