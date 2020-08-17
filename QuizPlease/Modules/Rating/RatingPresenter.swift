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
    
    func handleRefreshControl(completion: (() -> Void)?)
    
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
        loadRating()
    }
    
    func handleRefreshControl(completion: (() -> Void)?) {
        loadRating(completion)
    }
    
    private func loadRating(_ completion: (() -> Void)? = nil) {
        interactor.loadRating { [weak self] (result) in
            completion?()
            guard let self = self else { return }
            
            switch result {
            case .failure(let error):
                self.view?.showSimpleAlert(title: "Произошла ошибка", message: error.localizedDescription)
                
            case .success(let teams):
                self.teams = teams
                self.view?.reloadRatingList()
            }
        }
    }
        
}
