//
//  GameOrderConfigurator.swift
//  QuizPlease
//
//  Created by Владислав on 13.08.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import UIKit

protocol GameOrderConfiguratorProtocol {
    func configure(_ viewController: GameOrderViewProtocol, withGameInfo gameInfo: GameInfoPresentAttributes)
}

class GameOrderConfigurator: GameOrderConfiguratorProtocol {
    func configure(_ viewController: GameOrderViewProtocol, withGameInfo gameInfo: GameInfoPresentAttributes) {
        let interactor = GameOrderInteractor()
        let router = GameOrderRouter(viewController: viewController)
        let presenter = GameOrderPresenter(view: viewController, interactor: interactor, router: router)
        presenter.game = gameInfo.game
        
        viewController.presenter = presenter
        viewController.shouldScrollToSignUp = gameInfo.shouldScrollToSignUp
        viewController.prepareNavigationBar(title: "\(gameInfo.game.nameGame) \(gameInfo.game.gameNumber)")
    }
    
}
