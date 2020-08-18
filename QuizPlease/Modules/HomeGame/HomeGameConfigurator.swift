//
//  HomeGameConfigurator.swift
//  QuizPlease
//
//  Created by Владислав on 04.08.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import UIKit

protocol HomeGameConfiguratorProtocol: class {
    func configure(view: HomeGameViewProtocol)
}

class HomeGameConfigurator: HomeGameConfiguratorProtocol {
    func configure(view: HomeGameViewProtocol) {
        let interactor = HomeGameInteractor()
        let router = HomeGameRouter(viewController: view)
        let presenter = HomeGamePresenter(view: view, interactor: interactor, router: router)
        
        view.presenter = presenter
        view.clearNavBarBackground()
        view.prepareNavigationBar(tintColor: .white)
    }
    
}
