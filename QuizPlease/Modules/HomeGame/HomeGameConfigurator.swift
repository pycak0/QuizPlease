//
//  HomeGameConfigurator.swift
//  QuizPlease
//
//  Created by Владислав on 04.08.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import UIKit

final class HomeGameConfigurator: Configurator {

    private let service = ServiceAssembly.shared

    func configure(_ view: HomeGameViewProtocol) {
        let interactor = HomeGameInteractor()
        let router = HomeGameRouter(viewController: view)
        let presenter = HomeGamePresenter(
            interactor: interactor,
            router: router,
            analyticsService: service.analytics
        )
        presenter.view = view
        view.presenter = presenter
        view.clearNavBarBackground()
        view.prepareNavigationBar(tintColor: .white, barStyle: .transparent)
    }
}
