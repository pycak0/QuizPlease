//
//  ShopConfigurator.swift
//  QuizPlease
//
//  Created by Владислав on 05.08.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import Foundation

protocol ShopConfiguratorProtocol {
    func configure(_ view: ShopViewProtocol, userInfo: UserInfo?)
}

class ShopConfigurator: ShopConfiguratorProtocol {

    let service: ServiceAssembly = .shared

    func configure(_ view: ShopViewProtocol, userInfo: UserInfo?) {
        let interactor = ShopInteractor(
            userService: service.userService
        )
        let router = ShopRouter(viewController: view)
        let presenter = ShopPresenter(view: view, interactor: interactor, router: router)
        presenter.userInfo = userInfo

        view.presenter = presenter
    }
}
