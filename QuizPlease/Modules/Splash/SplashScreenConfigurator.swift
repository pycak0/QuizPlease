//
//  SplashScreenConfigurator.swift
//  QuizPlease
//
//  Created by Владислав on 12.04.2021.
//  Copyright © 2021 Владислав. All rights reserved.
//

import Foundation

class SplashScreenConfigurator: Configurator {
    func configure(_ view: SplashScreenViewProtocol) {
        let interactor = SplashScreenInteractor()
        let router = SplashScreenRouter(viewController: view)
        let presenter = SplashScreenPresenter(view: view, interactor: interactor, router: router)
        interactor.interactorOutput = presenter
        view.presenter = presenter
    }
}
