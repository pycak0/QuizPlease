//
//  ShopConfigurator.swift
//  QuizPlease
//
//  Created by Владислав on 05.08.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import Foundation

protocol ShopConfiguratorProtocol {
    func configure(_ view: ShopViewProtocol)
}

class ShopConfigurator: ShopConfiguratorProtocol {
    func configure(_ view: ShopViewProtocol) {
        let interactor = ShopInteractor()
        let router = ShopRouter(viewController: view)
        let presenter = ShopPresenter(view: view, interactor: interactor, router: router)
        
        view.presenter = presenter
        view.prepareNavigationBar()
    }
}
