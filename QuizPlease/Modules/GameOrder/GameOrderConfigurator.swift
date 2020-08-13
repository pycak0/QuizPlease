//
//  GameOrderConfigurator.swift
//  QuizPlease
//
//  Created by Владислав on 13.08.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import UIKit

protocol GameOrderConfiguratorProtocol {
    func configure(_ viewController: GameOrderViewProtocol, withGame game: GameInfo)
}

class GameOrderConfigurator: GameOrderConfiguratorProtocol {
    func configure(_ viewController: GameOrderViewProtocol, withGame game: GameInfo) {
        let interactor = GameOrderInteractor()
        let router = GameOrderRouter(viewController: viewController)
        let presenter = GameOrderPresenter(view: viewController, interactor: interactor, router: router)
        presenter.game = game
        
        viewController.presenter = presenter
        viewController.prepareNavigationBar(title: "\(game.name) #\(game.gameNumber)")
    }
    
}
