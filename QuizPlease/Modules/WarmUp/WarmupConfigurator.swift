//
//  WarmupConfigurator.swift
//  QuizPlease
//
//  Created by Владислав on 04.08.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import Foundation

class WarmupConfigurator: Configurator {
    func configure(_ view: WarmupViewProtocol) {
        let interactor = WarmupInteractor()
        let router = WarmupRouter(viewController: view)
        let presenter = WarmupPresenter(view: view, interactor: interactor, router: router)
        
        view.presenter = presenter
        view.prepareNavigationBar(tintColor: .white)
    }
}
