//
//  GameOrderConfigurator.swift
//  QuizPlease
//
//  Created by Владислав on 13.08.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import UIKit

protocol GameOrderConfiguratorProtocol {
    func configure(_ viewController: GameOrderViewProtocol, with gameInfo: GameOrderPresentationOptions)
}

class GameOrderConfigurator: GameOrderConfiguratorProtocol {
    func configure(_ viewController: GameOrderViewProtocol, with options: GameOrderPresentationOptions) {
        let interactor = GameOrderInteractor()
        let router = GameOrderRouter(viewController: viewController)
        let presenter = GameOrderPresenter(
            view: viewController,
            interactor: interactor,
            router: router,
            registerForm: RegisterForm(
                cityId: options.city.id,
                gameId: options.gameInfo.id
            ),
            gameInfo: options.gameInfo
        )
        presenter.game = options.gameInfo
        interactor.output = presenter
        viewController.presenter = presenter
        viewController.shouldScrollToSignUp = options.shouldScrollToSignUp
        viewController.prepareNavigationBar(title: options.gameInfo.fullTitle)
    }
}
