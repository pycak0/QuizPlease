//
//  RatingConfigurator.swift
//  QuizPlease
//
//  Created by Владислав on 04.08.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import Foundation

final class RatingConfigurator: Configurator {

    private let service = ServiceAssembly.shared

    func configure(_ view: RatingViewProtocol) {
        let interactor = RatingInteractor()
        let router = RatingRouter(viewController: view)
        let presenter = RatingPresenter(
            interactor: interactor,
            router: router,
            analyticsService: service.analytics
        )
        presenter.view = view
        interactor.output = presenter
        view.presenter = presenter
        let color = view.view.backgroundColor
        view.prepareNavigationBar(
            tintColor: .white,
            barStyle: .transcluent(tintColor: color),
            scrollBarStyle: .transcluent(tintColor: color?.withAlphaComponent(0.9))
        )
    }
}
