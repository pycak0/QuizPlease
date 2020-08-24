//
//  HomeGamePresenter.swift
//  QuizPlease
//
//  Created by Владислав on 04.08.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import Foundation

protocol HomeGamePresenterProtocol {
    var router: HomeGameRouterProtocol! { get }
    var games: [HomeGame] { get set }
    init(view: HomeGameViewProtocol, interactor: HomeGameInteractorProtocol, router: HomeGameRouterProtocol)
    
    func configureViews()
    func didSelectHomeGame(at index: Int)
}

class HomeGamePresenter: HomeGamePresenterProtocol {
    var router: HomeGameRouterProtocol!
    var interactor: HomeGameInteractorProtocol!
    weak var view: HomeGameViewProtocol?
    
    var games: [HomeGame] = []
    
    required init(view: HomeGameViewProtocol, interactor: HomeGameInteractorProtocol, router: HomeGameRouterProtocol) {
        self.view = view
        self.router = router
        self.interactor = interactor
    }
    
    func configureViews() {
        view?.congigureCollectionView()
        
        interactor.loadHomeGames { (result) in
            switch result {
            case .failure(let error):
                print(error)
                self.view?.showErrorConnectingToServerAlert()
            case .success(let games):
                self.games = games
                self.view?.reloadHomeGamesList()
            }
        }
    }
    
    func didSelectHomeGame(at index: Int) {
        router.showGame(games[index])
    }
    
}
