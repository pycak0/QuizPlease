//
//  MainMenuConfigurator.swift
//  QuizPlease
//
//  Created by Владислав on 03.08.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import UIKit

class MainMenuConfigurator: Configurator {
    func configure(_ mainMenuVC: MainMenuViewProtocol) {
        let interactor = MainMenuInteractor()
        let router = MainMenuRouter(viewController: mainMenuVC)
        let presenter = MainMenuPresenter(view: mainMenuVC, interactor: interactor, router: router)
        interactor.output = presenter
        mainMenuVC.prepareNavigationBar()
        mainMenuVC.presenter = presenter
    }
}
