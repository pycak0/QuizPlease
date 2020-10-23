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
    //var teams: [RatingItem] { get set }
    
    var filteredTeams: [RatingItem] { get }
    
    func handleRefreshControl()
    
    func configureViews()
    
    func didChangeLeague(_ selectedIndex: Int)
    func didChangeRatingScope(_ rawValue: Int)
    func didChangeTeamName(_ name: String)
    func searchByTeamName(_ name: String)
}

class RatingPresenter: RatingPresenterProtocol {
    var router: RatingRouterProtocol!
    var interactor: RatingInteractorProtocol!
    weak var view: RatingViewProtocol?
    
    var teams: [RatingItem] = []
    var filteredTeams: [RatingItem] = []
    
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
        filteredTeams = teams.filter { $0.name.lowercased().contains(name.lowercased()) }
        view?.reloadRatingList()
        if filteredTeams.count == 0 {
            searchByTeamName(name)
        }
    }
    
    func searchByTeamName(_ name: String) {
        filter.teamName = name
        view?.startLoadingAnimation()
        loadRating()
    }
    
    func configureViews() {
        view?.configureTableView()
        loadRating()
    }
    
    func handleRefreshControl() {
        loadRating()
    }
    
    private func loadRating() {
        interactor.loadRating(with: filter) { [weak self] (result) in
            guard let self = self else { return }
            self.view?.endLoadingAnimation()
            
            switch result {
            case .failure(let error):
                print(error)
                self.view?.showErrorConnectingToServerAlert()
                //self.view?.showSimpleAlert(title: "Произошла ошибка", message: error.localizedDescription)
                
            case .success(let teams):
                self.teams = teams
                self.filteredTeams = teams
                self.view?.reloadRatingList()
            }
        }
    }
        
}
