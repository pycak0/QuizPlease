//
//  ProfileConfigurator.swift
//  QuizPlease
//
//  Created by Владислав on 04.08.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import Foundation

protocol ProfileConfiguratorProtocol {
    func configure(_ view: ProfileViewProtocol, userInfo: UserInfo?)
}

final class ProfileConfigurator: ProfileConfiguratorProtocol {

    let service = ServiceAssembly.shared

    func configure(_ view: ProfileViewProtocol, userInfo: UserInfo?) {
        let interactor = ProfileInteractor(
            userService: service.userService,
            log: service.core.logger
        )
        let router = ProfileRouter(
            viewController: view,
            onboardingAssembly: OnboardingAssembly(),
            webPageRouter: service.core.webPageRouter
        )
        let presenter = ProfilePresenter(view: view, interactor: interactor, router: router)
        presenter.userInfo = userInfo
        interactor.delegate = presenter

        view.presenter = presenter
    }
}
