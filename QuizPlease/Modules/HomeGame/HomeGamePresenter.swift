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
    init(view: HomeGameViewProtocol, interactor: HomeGameInteractorProtocol, router: HomeGameRouterProtocol)
    
    func configureViews()
}

class HomeGamePresenter: HomeGamePresenterProtocol {
    var router: HomeGameRouterProtocol!
    var interactor: HomeGameInteractorProtocol!
    weak var view: HomeGameViewProtocol?
    
    required init(view: HomeGameViewProtocol, interactor: HomeGameInteractorProtocol, router: HomeGameRouterProtocol) {
        self.view = view
        self.router = router
        self.interactor = interactor
    }
    
    func configureViews() {
        view?.congigureCollectionView()
    }
    
}
