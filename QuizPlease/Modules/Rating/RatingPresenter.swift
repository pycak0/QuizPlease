//
//  RatingPresenter.swift
//  QuizPlease
//
//  Created by Владислав on 04.08.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import Foundation

// MARK: - Presenter Protocol
protocol RatingPresenterProtocol {
    var router: RatingRouterProtocol! { get set }
    init(view: RatingViewProtocol, interactor: RatingInteractorProtocol, router: RatingRouterProtocol)

    var filter: RatingFilter { get set }
    var availableGameTypeNames: [String] { get }
    // var teams: [RatingItem] { get set }

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

    func needsLoadingMoreItems()
    func cancelPrefetching()
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

    // MARK: - Actions
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
        searchByTeamName(name)
//        filteredTeams = teams.filter { $0.name.lowercased().contains(name.lowercased()) }
//        if filteredTeams.isEmpty {
//            searchByTeamName(name)
//        } else {
//            view?.reloadRatingList()
//        }
    }

    func didPressSearchButton(with query: String) {
        searchByTeamName(query)
    }

    func didHideKeyboard(with query: String) {
        // nothing
    }

    func searchByTeamName(_ name: String) {
        filter.teamName = name
        // view?.startLoading()
        reloadRating(afterDelay: 0.5)
    }

    func viewDidLoad(_ view: RatingViewProtocol) {
        view.configure()
        updateHeaderContent()
        loadRating()
    }

    func handleRefreshControl() {
        reloadRating()
    }

    func needsLoadingMoreItems() {
        currentPage += 1
        loadRating()
    }

    func cancelPrefetching() {
        interactor.cancelLoading()
    }

    private func updateHeaderContent() {
        view?.setHeaderLabelContent(
            city: filter.city.title,
            leagueComment: filter.league.comment,
            ratingScopeComment: filter.scope.comment
        )
    }

    private func resetData() {
        currentPage = firstPageNumber
        teams.removeAll()
        filteredTeams.removeAll()
        view?.reloadRatingList()
    }

    // MARK: - Load
    /// Resets `currentPage` value to `1`, clears `teams` array and reloads view, then calls `loadRating` method
    private func reloadRating(afterDelay delay: Double = 0) {
        resetData()
        loadRating(afterDelay: delay)
    }

    /// Calls interactor's `loadRating` method using value of the `currentPage` without changing it
    private func loadRating(afterDelay delay: Double = 0) {
        view?.startLoading()
        interactor.loadRating(with: filter, page: currentPage, delay: delay)
    }
}

// MARK: - RatingInteractorOutput
extension RatingPresenter: RatingInteractorOutput {
    func interactor(_ interactor: RatingInteractorProtocol, errorOccured error: NetworkServiceError) {
        print(error)
        switch error {
        case let .other(otherError):
            let nsError = otherError as NSError
            print(nsError.code)
            if nsError.code == NSURLErrorCancelled || nsError.code == -999 {
                view?.stopLoading()
                return
            }
        default:
            break
        }
        view?.stopLoading()
        view?.showErrorConnectingToServerAlert()
    }

    func interactor(_ interactor: RatingInteractorProtocol, didLoadRatingItems ratingItems: [RatingItem]) {
        view?.stopLoading()
        var indices = 0..<0
        if currentPage > firstPageNumber {
            let filteredTeams = ratingItems.filter { !teams.contains($0) }
            guard !filteredTeams.isEmpty else { return }

            let startIndex = teams.count
            teams += filteredTeams
            indices = startIndex..<teams.count
        } else {
            teams = ratingItems
        }

        filteredTeams = teams

        if !indices.isEmpty {
            view?.appendRatingItems(at: indices)
        } else {
            view?.reloadRatingList()
        }
    }
}
