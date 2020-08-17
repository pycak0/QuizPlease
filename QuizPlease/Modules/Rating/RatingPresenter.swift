//
//  RatingPresenter.swift
//  QuizPlease
//
//  Created by Владислав on 04.08.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import Foundation

protocol RatingPresenterProtocol {
    var router: RatingRouterProtocol! { get set }
    init(view: RatingViewProtocol, interactor: RatingInteractorProtocol, router: RatingRouterProtocol)
    
    var teams: [Team] { get set }
    
    func configureViews()
    
}

class RatingPresenter: RatingPresenterProtocol {
    var router: RatingRouterProtocol!
    var interactor: RatingInteractorProtocol!
    weak var view: RatingViewProtocol?
    
    var teams: [Team] = []
    
    required init(view: RatingViewProtocol, interactor: RatingInteractorProtocol, router: RatingRouterProtocol) {
        self.router = router
        self.interactor = interactor
        self.view = view
    }
    
    func configureViews() {
        view?.configureTableView()
    }
    
}
