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
    
    var filter: RatingFilter { get set }
    var availableGameTypeNames: [String] { get }
    var teams: [RatingItem] { get set }
    
    func handleRefreshControl(completion: (() -> Void)?)
    
    func configureViews()
    
    func didChangeLeague(_ selectedIndex: Int)
    func didChangeRatingScope(_ rawValue: Int)
    func didChangeTeamName(_ name: String)
}

class RatingPresenter: RatingPresenterProtocol {
    var router: RatingRouterProtocol!
    var interactor: RatingInteractorProtocol!
    weak var view: RatingViewProtocol?
    
    var teams: [RatingItem] = []
    let availableGameTypeNames = RatingFilter.RatingLeague.allCases.map { $0.name }
    var filter = RatingFilter(scope: .season)
    
    required init(view: RatingViewProtocol, interactor: RatingInteractorProtocol, router: RatingRouterProtocol) {
        self.router = router
        self.interactor = interactor
        self.view = view
    }
    
    func didChangeLeague(_ selectedIndex: Int) {
        let league = RatingFilter.RatingLeague.allCases[selectedIndex]
        filter.league = league
        loadRating()
    }
    
    func didChangeRatingScope(_ rawValue: Int) {
        guard let scope = RatingFilter.RatingScope(rawValue: rawValue) else { return }
        filter.scope = scope
        loadRating()
    }
    
    func didChangeTeamName(_ name: String) {
        filter.teamName = name
        loadRating()
    }
    
    func configureViews() {
        view?.configureTableView()
        loadRating()
    }
    
    func handleRefreshControl(completion: (() -> Void)?) {
        loadRating(completion)
    }
    
    private func loadRating(_ completion: (() -> Void)? = nil) {
        interactor.loadRating(with: filter) { [weak self] (result) in
            completion?()
            guard let self = self else { return }
            
            switch result {
            case .failure(let error):
                print(error)
                self.view?.showErrorConnectingToServerAlert()
                //self.view?.showSimpleAlert(title: "Произошла ошибка", message: error.localizedDescription)
                
            case .success(let teams):
                self.teams = teams
                self.view?.reloadRatingList()
            }
        }
    }
        
}
