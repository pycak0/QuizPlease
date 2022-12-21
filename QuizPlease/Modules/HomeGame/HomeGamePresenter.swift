//
//  HomeGamePresenter.swift
//  QuizPlease
//
//  Created by Владислав on 04.08.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import Foundation

protocol HomeGamePresenterProtocol {
    var router: HomeGameRouterProtocol { get }
    var games: [HomeGame] { get set }

    func viewDidLoad(_ view: HomeGameViewProtocol)
    func didSelectHomeGame(at index: Int)
}

final class HomeGamePresenter: HomeGamePresenterProtocol {

    weak var view: HomeGameViewProtocol?

    let router: HomeGameRouterProtocol
    private let interactor: HomeGameInteractorProtocol
    private let analyticsService: AnalyticsService

    var games: [HomeGame] = []

    init(
        interactor: HomeGameInteractorProtocol,
        router: HomeGameRouterProtocol,
        analyticsService: AnalyticsService
    ) {
        self.interactor = interactor
        self.router = router
        self.analyticsService = analyticsService
    }

    func viewDidLoad(_ view: HomeGameViewProtocol) {
        interactor.loadHomeGames { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .failure(let error):
                print(error)
                self.view?.showErrorConnectingToServerAlert()
            case .success(let games):
                self.games = games
                self.view?.reloadHomeGamesList()
            }
        }
        analyticsService.sendEvent(.homeGameListOpen)
    }

    func didSelectHomeGame(at index: Int) {
        router.showGame(games[index])
    }
}
