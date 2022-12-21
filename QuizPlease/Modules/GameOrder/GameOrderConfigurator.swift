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

final class GameOrderConfigurator: GameOrderConfiguratorProtocol {

    let service = ServiceAssembly.shared

    func configure(_ viewController: GameOrderViewProtocol, with options: GameOrderPresentationOptions) {
        let interactor = GameOrderInteractor(
            networkService: NetworkService.shared,
            asyncExecutor: ConcurrentExecutorImpl()
        )
        let router = GameOrderRouter(viewController: viewController)
        let presenter = GameOrderPresenter(
            interactor: interactor,
            router: router,
            analyticsService: service.analytics,
            registerForm: RegisterForm(
                cityId: options.cityId,
                gameId: options.gameInfo.id
            ),
            gameInfo: options.gameInfo,
            scrollToSignUp: options.shouldScrollToSignUp,
            loadGameInfo: options.shouldLoadGameInfo
        )
        presenter.view = viewController
        presenter.game = options.gameInfo
        interactor.output = presenter
        viewController.presenter = presenter
    }
}
