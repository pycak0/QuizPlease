//
//  RatingPresenter.swift
//  QuizPlease
//
//  Created by Владислав on 04.08.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import Foundation

//MARK:- Presenter Protocol
protocol RatingPresenterProtocol {
    var router: RatingRouterProtocol! { get set }
    init(view: RatingViewProtocol, interactor: RatingInteractorProtocol, router: RatingRouterProtocol)
    
    var filter: RatingFilter { get set }
    var availableGameTypeNames: [String] { get }
    //var teams: [RatingItem] { get set }
    
    var availableFilters: [RatingFilter.RatingScope] { get }
    
    var filteredTeams: [RatingItem] { get }
    
    func handleRefreshControl()
    
    func viewDidLoad(_ view: RatingViewProtocol)
    
    func didChangeLeague(_ selectedIndex: Int)
    func didChangeRatingScope(_ rawValue: Int)
    func didChangeTeamName(_ name: String)
    func didPressSearchButton(with query: String)
    func didHideKeyboard(with query: String)
    func searchByTeamName(_ name: String)
    
    func didAlmostScrollToEnd()
}

class RatingPresenter: RatingPresenterProtocol {
    var router: RatingRouterProtocol!
    var interactor: RatingInteractorProtocol!
    weak var view: RatingViewProtocol?
    
    var teams: [RatingItem] = []
    var filteredTeams: [RatingItem] = []
    
    let availableGameTypeNames = RatingFilter.RatingLeague.allCases.map { $0.name }
    var filter = RatingFilter(scope: .season)
    
    var availableFilters: [RatingFilter.RatingScope] {
        return RatingFilter.RatingScope.allCases
    }
    
    private let firstPageNumber = 1
    private lazy var currentPage = firstPageNumber
    
    required init(view: RatingViewProtocol, interactor: RatingInteractorProtocol, router: RatingRouterProtocol) {
        self.router = router
        self.interactor = interactor
        self.view = view
    }
    
    //MARK:- Actions
    func didChangeLeague(_ selectedIndex: Int) {
        let league = RatingFilter.RatingLeague.allCases[selectedIndex]
        filter.league = league
        reloadRating()
        updateHeaderContent()
    }
    
    func didChangeRatingScope(_ rawValue: Int) {
        guard let scope = RatingFilter.RatingScope(rawValue: rawValue) else { return }
        filter.scope = scope
        reloadRating()
        updateHeaderContent()
    }
    
    func didChangeTeamName(_ name: String) {
        filteredTeams = teams.filter { $0.name.lowercased().contains(name.lowercased()) }
        if filteredTeams.isEmpty {
            searchByTeamName(name)
        } else {
            view?.reloadRatingList()
        }
    }
    
    func didPressSearchButton(with query: String) {
        searchByTeamName(query)
    }
    
    func didHideKeyboard(with query: String) {
        //nothing
    }
    
    func searchByTeamName(_ name: String) {
        filter.teamName = name
        //view?.startLoadingAnimation()
        reloadRating(delay: 0.5)
    }
    
    func viewDidLoad(_ view: RatingViewProtocol) {
        view.configure()
        updateHeaderContent()
        loadRating()
    }
    
    func handleRefreshControl() {
        reloadRating()
    }
    
    func didAlmostScrollToEnd() {
        currentPage += 1
        loadRating()
    }
    
    private func updateHeaderContent() {
        view?.setHeaderLabelContent(
            city: filter.city.title,
            league: filter.league.name,
            ratingScopeComment: filter.scope.comment
        )
    }
    
    private func resetData() {
        currentPage = firstPageNumber
        teams.removeAll()
        filteredTeams.removeAll()
        view?.reloadRatingList()
    }
    
    //MARK:- Load
    ///Resets `currentPage` value to `1`, clears `teams` array and reloads view, then calls `loadRating` method
    private func reloadRating(delay: Double = 0) {
        resetData()
        loadRating(delay: delay)
    }
    
    ///Calls interactor's `loadRating` method using value of the `currentPage` without changing it
    private func loadRating(delay: Double = 0) {
        view?.startLoadingAnimation()
        interactor.loadRating(with: filter, page: currentPage, delay: delay)
    }
}

//MARK:- RatingInteractorOutput
extension RatingPresenter: RatingInteractorOutput {
    func interactor(_ interactor: RatingInteractorProtocol, errorOccured error: SessionError) {
        print(error)
        view?.endLoadingAnimation()
        view?.showErrorConnectingToServerAlert()
        //view?.showSimpleAlert(title: "Произошла ошибка", message: error.localizedDescription)
    }
    
    func interactor(_ interactor: RatingInteractorProtocol, didLoadRatingItems ratingItems: [RatingItem]) {
        view?.endLoadingAnimation()
        var indices = 0..<0
        if self.currentPage > self.firstPageNumber {
            let filteredTeams = ratingItems.filter { !self.teams.contains($0) }
            guard !filteredTeams.isEmpty else { return }
            
            let startIndex = self.teams.count
            self.teams += filteredTeams
            indices = startIndex..<self.teams.count
        } else {
            self.teams = ratingItems
        }
        
        self.filteredTeams = self.teams
        
        if !indices.isEmpty {
            self.view?.appendRaingItems(at: indices)
        } else {
            self.view?.reloadRatingList()
        }
    }
}
