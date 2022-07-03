//
//  HomeGameConfigurator.swift
//  QuizPlease
//
//  Created by Владислав on 04.08.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import UIKit

class HomeGameConfigurator: Configurator {
    func configure(_ view: HomeGameViewProtocol) {
        let interactor = HomeGameInteractor()
        let router = HomeGameRouter(viewController: view)
        let presenter = HomeGamePresenter(view: view, interactor: interactor, router: router)

        view.presenter = presenter
        view.clearNavBarBackground()
        view.prepareNavigationBar(tintColor: .white, barStyle: .transparent)
    }
}
