//
//  ScheduleConfigurator.swift
//  QuizPlease
//
//  Created by Владислав on 04.08.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import Foundation

final class ScheduleConfigurator: Configurator {

    private let services = ServiceAssembly.shared

    func configure(_ view: ScheduleViewProtocol) {
        let router = ScheduleRouter(viewController: view)
        let interactor = ScheduleInteractor(gameInfoLoader: services.gameInfoLoader)
        let presenter = SchedulePresenter(
            interactor: interactor,
            router: router,
            analyticsService: services.analytics
        )
        presenter.view = view
        view.presenter = presenter
        interactor.output = presenter
    }
}
