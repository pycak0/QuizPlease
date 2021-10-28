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
        let interactor = WarmupInteractor(
            questionsService: AppSettings.isDebug ?
                WarmupQuestionsServiceMock(maxNumberOfQuestions: 3) : NetworkService.shared
        )
        let router = WarmupRouter(
            viewController: view,
            shareSheet: ShareSheet()
        )
        let presenter = WarmupPresenter(view: view, interactor: interactor, router: router)
        interactor.output = presenter
        view.presenter = presenter
        view.prepareNavigationBar(tintColor: .white, barStyle: .opaque(tintColor: view.view.backgroundColor))
    }
}
