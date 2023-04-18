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
    private let launchOptions: GamePageLaunchOptions

    init(launchOptions: GamePageLaunchOptions) {
        self.launchOptions = launchOptions
    }
}

// MARK: - ViewAssembly

extension GamePageAssembly: ViewAssembly {

    // swiftlint:disable:next function_body_length
    func makeViewController() -> UIViewController {
        let paymentSumCalculator = PaymentSumCalculatorImpl()
        let registrationService = RegistrationService(
            gameId: launchOptions.gameId,
            networkService: services.networkService
        )
        let interactor = GamePageInteractor(
            gameId: launchOptions.gameId,
            gameInfoLoader: services.gameInfoLoader,
            placeGeocoder: services.placeGeocoder,
            registrationService: registrationService,
            paymentSumCalculator: paymentSumCalculator
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
        let paymentBuilder = GamePagePaymentSectionBuilder(paymentInfoProvider: interactor)
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
            paymentBuilder: paymentBuilder,
            submitBuilder: submitBuilder
        )
        let router = GamePageRouter(
            webPageRouter: services.core.webPageRouter
        )
        let presenter = GamePagePresenter(
            itemFactory: itemFactory,
            interactor: interactor,
            router: router,
            shouldScrollToRegistrationOnLoad: launchOptions.shouldScrollToRegistration
        )
        let viewController = GamePageViewController(output: presenter)

        registerButtonBuilder.output = presenter
        infoBuilder.output = presenter
        registrationFieldsBuilder.output = presenter
        specialConditionsBuilder.output = presenter
        paymentBuilder.output = presenter
        submitBuilder.output = presenter

        specialConditionsBuilder.view = viewController
        paymentBuilder.viewUpdater = viewController
        presenter.view = viewController
        router.viewController = viewController

        return viewController
    }
}
