//
//  ScheduleConfigurator.swift
//  QuizPlease
//
//  Created by Владислав on 04.08.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import Foundation

class ScheduleConfigurator: Configurator {
    func configure(_ view: ScheduleViewProtocol) {
        let router = ScheduleRouter(viewController: view)
        let interactor = ScheduleInteractor()
        let presenter = SchedulePresenter(view: view, interactor: interactor, router: router)
        view.prepareNavigationBar()
        view.presenter = presenter
        interactor.output = presenter
    }
}
