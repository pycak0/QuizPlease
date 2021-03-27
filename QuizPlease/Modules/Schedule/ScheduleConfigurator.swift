//
//  ScheduleConfigurator.swift
//  QuizPlease
//
//  Created by Владислав on 04.08.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import Foundation

protocol ScheduleConfiguratorProtocol {
    func configure(_ viewController: ScheduleViewProtocol)
}

class ScheduleConfigurator: ScheduleConfiguratorProtocol {
    func configure(_ viewController: ScheduleViewProtocol) {
        let router = ScheduleRouter(viewController: viewController)
        let interactor = ScheduleInteractor()
        let presenter = SchedulePresenter(view: viewController, interactor: interactor, router: router)
        
        viewController.prepareNavigationBar()
        viewController.presenter = presenter
        interactor.output = presenter
    }
    
}
