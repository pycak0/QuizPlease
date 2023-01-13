//
//  WarmupConfigurator.swift
//  QuizPlease
//
//  Created by Владислав on 04.08.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import Foundation

final class WarmupConfigurator: Configurator {

    private let service = ServiceAssembly.shared

    func configure(_ view: WarmupViewProtocol) {
        let enableWarmupQuestionsSerivceStubInDebug = true
        let interactor = WarmupInteractor(
            questionsService: AppSettings.isDebug && enableWarmupQuestionsSerivceStubInDebug
            ? WarmupQuestionsServiceStub(maxNumberOfQuestions: 3)
            : WarmupQuestionsServiceImpl(
                networkService: .shared,
                deviceIdProvider: AppSettings.isDebug ? DeviceIdProviderStub() : DeviceIdProviderImpl()
            )
        )
        let router = WarmupRouter(
            viewController: view,
            shareSheet: ShareSheet()
        )
        let presenter = WarmupPresenter(
            interactor: interactor,
            router: router,
            analyticsService: service.analytics
        )
        presenter.view = view
        interactor.output = presenter
        view.presenter = presenter
        view.prepareNavigationBar(tintColor: .white, barStyle: .opaque(tintColor: view.view.backgroundColor))
    }
}
