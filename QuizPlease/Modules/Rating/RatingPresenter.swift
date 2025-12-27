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

    var router: RatingRouterProtocol { get }

    var filter: RatingFilter { get set }
    var availableGameTypeNames: [String] { get }
    var availableFilters: [RatingFilter.RatingScope] { get }

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

final class RatingPresenter: RatingPresenterProtocol {

    weak var view: RatingViewProtocol?

    let router: RatingRouterProtocol
    private let interactor: RatingInteractorProtocol
    private let analyticsService: AnalyticsService
    private let ratingItemMapper: RatingTeamDataToItemMapper
    private let log: Logger

    private var leagues: [RatingLeagueData] = []

    var teams: [RatingTeamItem] = []
    var filteredTeams: [RatingTeamItem] = []

    var availableGameTypeNames: [String] {
        leagues.map { $0.title }
    }
    var filter = RatingFilter(scope: .season)

    var availableFilters: [RatingFilter.RatingScope] {
        return RatingFilter.RatingScope.allCases
    }

    private let firstPageNumber = 1
    private lazy var currentPage = firstPageNumber

    init(
        interactor: RatingInteractorProtocol,
        router: RatingRouterProtocol,
        analyticsService: AnalyticsService,
        ratingItemMapper: RatingTeamDataToItemMapper,
        log: Logger
    ) {
        self.interactor = interactor
        self.router = router
        self.analyticsService = analyticsService
        self.ratingItemMapper = ratingItemMapper
        self.log = log
    }

    // MARK: - Actions
    func didChangeLeague(_ selectedIndex: Int) {
        guard leagues.indices.contains(selectedIndex) else { return }
        let league = leagues[selectedIndex]
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
    }

    func didPressSearchButton(with query: String) {
        searchByTeamName(query)
    }

    func didHideKeyboard(with query: String) {
        // nothing
    }

    func searchByTeamName(_ name: String) {
        filter.teamName = name
        reloadRating(afterDelay: 0.5)
    }

    func viewDidLoad(_ view: RatingViewProtocol) {
        setHeaderLoading()
        view.startLoading()
        interactor.loadLeagues()
        analyticsService.sendEvent(.ratingOpen)
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

    private func setHeaderLoading() {
        view?.setHeaderLabelContent("Загрузка…")
    }

    private func updateHeaderContent() {
        let league = filter.league?.title.appending(" ") ?? ""
        let scope = filter.scope.comment
        let city = filter.city.title
        let headerText = "Рейтинг \(league)\(scope) в городе: \(city)"
        view?.setHeaderLabelContent(headerText)
    }

    private func resetData() {
        currentPage = firstPageNumber
        teams.removeAll()
        filteredTeams.removeAll()
        view?.setItems([])
    }

    // MARK: - Load
    /// Resets `currentPage` value to `1`, clears `teams` array and reloads view, then calls `loadRating` method
    private func reloadRating(afterDelay delay: Double = 0) {
        resetData()
        loadRating(afterDelay: delay)
    }

    /// Calls interactor's `loadRating` method using value of the `currentPage` without changing it
    private func loadRating(afterDelay delay: Double = 0) {
        guard filter.league?.id != nil else {
            log.error("Attempted to load rating without a selected league")
            return
        }
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

    func interactor(_ interactor: RatingInteractorProtocol, didLoadLeagues leagues: [RatingLeagueData]) {
        self.leagues = leagues

        if filter.league == nil, let first = leagues.first {
            filter.league = first
            view?.configureHeaderWithFilters()
            updateHeaderContent()
        }

        loadRating()
    }

    func interactor(_ interactor: RatingInteractorProtocol, didLoadRatingItems ratingDataItems: [RatingTeamItemData]) {
        view?.stopLoading()

        let startingPlace = teams.count + 1
        let ratingItems = ratingItemMapper.map(ratingDataItems, startingPlace: startingPlace)

        if currentPage > firstPageNumber {
            let filteredTeams = ratingItems.filter { !teams.contains($0) }
            guard !filteredTeams.isEmpty else { return }

            teams += filteredTeams
            view?.addItems(filteredTeams)

        } else if !ratingItems.isEmpty {
            teams = ratingItems
            view?.setItems(teams)
        } else {
            let emptyItem = RatingEmptyItem(
                title: "Упс. А рейтинга пока нет, мы работаем над этим!",
                imageName: "cat"
            )
            view?.setItems([emptyItem])
        }

        filteredTeams = teams
    }
}
