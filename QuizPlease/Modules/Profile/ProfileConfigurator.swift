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
    func configure(_ view: ProfileViewProtocol, userInfo: UserInfo?) {
        let interactor = ProfileInteractor(networkService: NetworkService.shared)
        let router = ProfileRouter(
            viewController: view,
            onboardingAssembly: OnboardingAssembly()
        )
        let presenter = ProfilePresenter(view: view, interactor: interactor, router: router)
        presenter.userInfo = userInfo
        interactor.delegate = presenter

        view.presenter = presenter
    }
}
