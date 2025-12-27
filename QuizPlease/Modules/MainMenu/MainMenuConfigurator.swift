//
//  MainMenuConfigurator.swift
//  QuizPlease
//
//  Created by Владислав on 03.08.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import UIKit

final class MainMenuConfigurator: Configurator {

    private let services = ServiceAssembly.shared

    func configure(_ mainMenuVC: MainMenuViewProtocol) {
        let interactor = MainMenuInteractor(
            notificationService: services.notificationService
        )
        let router = MainMenuRouter(
            viewController: mainMenuVC,
            pickCityAssembly: PickCityAssembly(),
            webPageRouter: services.core.webPageRouter
        )
        let presenter = MainMenuPresenter(view: mainMenuVC, interactor: interactor, router: router)
        interactor.output = presenter
        mainMenuVC.prepareNavigationBar(barStyle: .transcluent(tintColor: .clear))
        mainMenuVC.presenter = presenter
    }
}
