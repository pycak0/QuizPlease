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
        let registrationService = RegistrationService(
            gameId: gameId,
            gameInfoLoader: services.gameInfoLoader
        )
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
        let registrationFieldsBuilder = GamePageRegistrationFieldsBuilder(
            registerFormProvider: registrationService
        )
        let specialConditionsBuilder = GamePageSpecialConditionsBuilder(
            specialConditionsProvider: registrationService
        )
        let firstPlayBuilder = GamePageFirstPlayBuilder(
            registerFormProvider: registrationService
        )
        let submitBuilder = GamePageSubmitBuilder(
            titleProvider: interactor
        )
        let itemFactory = GamePageItemFactory(
            gameStatusProvider: interactor,
            annotationBuilder: annotationBuilder,
            registerButtonBuilder: registerButtonBuilder,
            infoBuilder: infoBuilder,
            descriptionBuilder: descriptionBuilder,
            registrationFieldsBuilder: registrationFieldsBuilder,
            specialConditionsBuilder: specialConditionsBuilder,
            firstPlayBuilder: firstPlayBuilder,
            submitBuilder: submitBuilder
        )
        let router = GamePageRouter(
            webPageRouter: services.core.webPageRouter
        )
        let presenter = GamePagePresenter(
            itemFactory: itemFactory,
            interactor: interactor,
            router: router
        )
        let viewController = GamePageViewController(output: presenter)

        infoBuilder.output = presenter
        registerButtonBuilder.output = presenter
        specialConditionsBuilder.view = viewController
        submitBuilder.output = presenter
        presenter.view = viewController
        router.viewController = viewController

        return viewController
    }
}
