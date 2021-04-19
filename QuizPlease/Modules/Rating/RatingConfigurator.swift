//
//  RatingConfigurator.swift
//  QuizPlease
//
//  Created by Владислав on 04.08.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import Foundation

protocol RatingConfiguratorProtocol {
    func configure(_ view: RatingViewProtocol)
}

class RatingConfigurator: RatingConfiguratorProtocol {
    func configure(_ view: RatingViewProtocol) {
        let interactor = RatingInteractor()
        let router = RatingRouter(viewController: view)
        let presenter = RatingPresenter(view: view, interactor: interactor, router: router)
        interactor.output = presenter
        view.presenter = presenter
        view.prepareNavigationBar(tintColor: .white)
    }
}
