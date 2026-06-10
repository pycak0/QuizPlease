//
//  SchedulePresenter.swift
//  QuizPlease
//
//  Created by Владислав on 04.08.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import Foundation

private enum Constants {
    /// Basic Schedule title
    static let scheduleSectionTitle = "Расписание игр"
    /// Schedule title for ended games
    static let endedGamesTitle = "Прошедшие игры"
    static let firstPage = 1
    static let paginationThreshold = 5
}

// MARK: - Presenter Protocol

protocol SchedulePresenterProtocol: AnyObject {

    var router: ScheduleRouterProtocol { get }

    var gamesCount: Int { get }

    func viewDidLoad(_ view: ScheduleViewProtocol)
    func didSignUp(forGameAt index: Int)
    func didPressInfoButton(forGameAt index: Int)
    func didAskNotification(forGameAt index: Int)
    func didAskLocation(forGameAt index: Int)

    func didPressFilterButton()
    func didChangeScheduleFilter(newFilter: ScheduleFilter)
    func didPressScheduleRemindButton()

    func handleRefreshControl()
    func updateDetailInfoIfNeeded(at index: Int)
    func didDisplayGame(at index: Int)

    func viewModel(forGameAt index: Int) -> ScheduleGameCellViewModel
}

// MARK: - Presenter Implementation

final class SchedulePresenter: SchedulePresenterProtocol {

    weak var view: ScheduleViewProtocol?

    let router: ScheduleRouterProtocol
    private let interactor: ScheduleInteractorProtocol
    private let analyticsService: AnalyticsService

    private var games: [GameInfo] = []
    private var scheduleFilter = ScheduleFilter()
    private var subscribedGameIds: Set<String> = Set()
    private var currentSchedulePage = 0
    private var hasMoreSchedulePages = true
    private var isLoadingSchedulePage = false
    private var scheduleLoadingToken = UUID()

    var gamesCount: Int {
        games.count
    }

    // MARK: - Lifecycle

    required init(
        interactor: ScheduleInteractorProtocol,
        router: ScheduleRouterProtocol,
        analyticsService: AnalyticsService
    ) {
        self.router = router
        self.interactor = interactor
        self.analyticsService = analyticsService
    }

    func viewDidLoad(_ view: ScheduleViewProtocol) {
        view.configure()
        updateSchedule()
        analyticsService.sendEvent(.scheduleOpen)
    }

    // MARK: - Schedule Cell View Model

    func viewModel(forGameAt index: Int) -> ScheduleGameCellViewModel {
        let game = games[index]
        let isSubscribed = isSubscribedOnGame(with: game.id)

        let subscribeButtonModel = SubscribeButtonViewModel(
            isPresented: game.showRemindButton,
            tintColor: isSubscribed ? .black : .white,
            backgroundColor: isSubscribed ? .lemon : .themePurple,
            title: isSubscribed ? "Напомним" : "Напомнить"
        )

        let extraInfoButton = ExtraInfoButtonViewModel(
            isPresented: game.gameStatus == .reserveAvailable,
            tapAction: { [weak self] in
                self?.showExtraInfoTextAlert()
            }
        )

        return ScheduleGameCellViewModel(
            gameInfo: game,
            subscribeButtonViewModel: subscribeButtonModel,
            extraInfoButtonViewModel: extraInfoButton
        )
    }

    private func isSubscribedOnGame(with id: String) -> Bool {
        return subscribedGameIds.contains(id)
    }

    // MARK: - Actions

    func didSignUp(forGameAt index: Int) {
        router.showGameInfo(
            with: gamePageLaunchOptions(gameIndex: index, scrollToSignUp: true)
        )
    }

    func didPressInfoButton(forGameAt index: Int) {
        let game = games[index]

        guard
            let status = game.gameStatus,
            status.allowsTransitionToDetails
        else {
            return
        }

        router.showGameInfo(
            with: gamePageLaunchOptions(gameIndex: index, scrollToSignUp: false)
        )
    }

    func didAskLocation(forGameAt index: Int) {
        let game = games[index]
        let place = game.placeInfo
        router.showMap(for: place)
    }

    func didAskNotification(forGameAt index: Int) {
        let id = games[index].id ?? ""
        interactor.getSubscribeStatus(gameId: id)
    }

    func didPressFilterButton() {
        router.showScheduleFilters(with: scheduleFilter)
    }

    func didChangeScheduleFilter(newFilter: ScheduleFilter) {
        scheduleFilter = newFilter
        updateSchedule()
        if newFilter.status?.id == GameStatus.ended.identifier {
            view?.setTitle(Constants.endedGamesTitle)
        } else {
            view?.setTitle(Constants.scheduleSectionTitle)
        }
    }

    func didPressScheduleRemindButton() {
        //
    }

    // MARK: - Handle Refresh Control

    func handleRefreshControl() {
        updateSchedule()
    }

    // MARK: - Loading

    func updateDetailInfoIfNeeded(at index: Int) {
        guard index < games.count else { return }
        let game = games[index]
        if game.nameGame == GameInfo.placeholderValue {
            updateDetailInfo(forGame: game, at: index)
        }
    }

    func didDisplayGame(at index: Int) {
        guard index >= games.count - Constants.paginationThreshold else { return }
        loadNextSchedulePage()
    }

    private func updateDetailInfo(forGame game: GameInfo, at index: Int) {
        interactor.loadDetailInfo(for: game) { [weak self] (fullInfo) in
            guard let self = self else { return }
            if let game = fullInfo, index < self.games.count {
                self.games[index] = game
                self.view?.reloadGame(at: index)
            }
        }
    }

    // MARK: - Load

    private func updateSchedule() {
        resetPagination()
        loadNextSchedulePage()
        updateSubscribedGames()
    }

    private func resetPagination() {
        currentSchedulePage = 0
        hasMoreSchedulePages = true
        isLoadingSchedulePage = false
        scheduleLoadingToken = UUID()
    }

    private func loadNextSchedulePage() {
        guard hasMoreSchedulePages, !isLoadingSchedulePage else { return }

        let pageToLoad = currentSchedulePage + 1
        let isFirstPage = pageToLoad == Constants.firstPage
        let loadingToken = scheduleLoadingToken
        isLoadingSchedulePage = true

        if isFirstPage {
            view?.startLoading()
        }

        interactor.loadSchedule(filter: scheduleFilter, page: pageToLoad) { [weak self] (result) in
            guard let self = self else { return }
            guard self.scheduleLoadingToken == loadingToken else { return }

            self.isLoadingSchedulePage = false
            if isFirstPage {
                self.view?.stopLoading()
            }

            switch result {
            case.failure(let error):
                print(error)
                if !isFirstPage {
                    self.hasMoreSchedulePages = false
                    self.view?.showErrorConnectingToServerAlert()
                    return
                }

                switch error {
                case .other, .serverError, .invalidUrl:
                    self.view?.showErrorConnectingToServerAlert { [weak self] _ in
                        self?.router.close()
                    }
                default:
                    self.games.removeAll()
                    self.view?.reloadScheduleList()
                    self.showNoGamesInSchedule()
                }

            case .success(let schedulePage):
                self.currentSchedulePage = pageToLoad
                self.hasMoreSchedulePages = schedulePage.hasMore
                if isFirstPage {
                    self.games = schedulePage.games
                    self.view?.reloadScheduleList()
                } else {
                    let startIndex = self.games.count
                    self.games.append(contentsOf: schedulePage.games)
                    if !schedulePage.games.isEmpty {
                        self.view?.insertScheduleGames(
                            startIndex: startIndex,
                            count: schedulePage.games.count
                        )
                    }
                }
                if isFirstPage && schedulePage.games.isEmpty {
                    self.showNoGamesInSchedule()
                }
            }
        }
    }

    private func updateSubscribedGames() {
        interactor.getSubscribedGameIds { [weak self] gameIds in
            guard let self = self else { return }
            self.subscribedGameIds = gameIds
        }
    }

    private func gamePageLaunchOptions(
        gameIndex: Int,
        scrollToSignUp: Bool
    ) -> GamePageLaunchOptions {
        let game = games[gameIndex]
        return GamePageLaunchOptions(
            gameId: game.id,
            shouldScrollToRegistration: scrollToSignUp
        )
    }

    private func showNoGamesInSchedule() {
        let links: [TextLink]
        let text: String
        if scheduleFilter.status?.id == GameStatus.ended.identifier {
            text = "Упс! А прошедших игр еще нет. Чтобы посмотреть предстоящие игры, " +
            "перейдите в раздел \(Constants.scheduleSectionTitle)"
            links = [
                TextLink(
                    text: Constants.scheduleSectionTitle,
                    action: { [weak self] in self?.resetFilterAndUpdateSchedule() }
                )
            ]

        } else {
            text = "Упс! Кажется, сейчас нет игр, на которые открыта регистрация, " +
            "поэтому пока вы можете размяться или сыграть в наши игры Хоум"
            links = [
                TextLink(
                    text: "игры Хоум",
                    action: { [weak self] in self?.showHomeGame() }
                ),
                TextLink(
                    text: "размяться",
                    action: { [weak self] in self?.showWarmup() }
                )
            ]
        }
        self.view?.showNoGamesInSchedule(text: text, links: links)
    }

    private func resetFilterAndUpdateSchedule() {
        scheduleFilter = ScheduleFilter()
        updateSchedule()
        view?.setTitle(Constants.scheduleSectionTitle)
    }

    private func showHomeGame() {
        router.showHomeGame(popCurrent: true)
    }

    private func showWarmup() {
        router.showWarmup(popCurrent: true)
    }

    private func showExtraInfoTextAlert() {
        interactor.getExtraInfoText { [weak self] alert in
            guard let self, let alert else { return }
            self.view?.showSimpleAlert(title: alert.title, message: alert.text)
        }
    }

    private func makeSubscriptionTitle(response: ScheduleGameSubscriptionResponse) -> String {
        if let title = response.title {
            return title
        }
        guard response.success else {
            return "Не удалось подписаться на уведомления"
        }
        switch response.message {
        case .subscribe:
            return "Мы напомним об игре"
        case .unsubscribe:
            return "Отписка от уведомлений"
        }
    }

    private func makeSubscriptionText(response: ScheduleGameSubscriptionResponse) -> String {
        if let message = response.text {
            return message
        }
        guard response.success else {
            return "Произошла ошибка при выполнении запроса"
        }
        switch response.message {
        case .subscribe:
            return "За два дня до начала или когда места для регистрации начнут заканчиваться"
        case .unsubscribe:
            return "Вы были успешно отписаны от уведомлений об игре. " +
            "Если хотите снова подписаться, нажмите на кнопку еще раз"
        }
    }
}

// MARK: - ScheduleInteractorOutput

extension SchedulePresenter: ScheduleInteractorOutput {

    func interactor(
        _ interactor: ScheduleInteractorProtocol?,
        didGetSubscribeStatus response: ScheduleGameSubscriptionResponse,
        forGameWithId id: String
    ) {
        switch response.message {
        case .subscribe:
            self.subscribedGameIds.insert(id)
        case .unsubscribe:
            self.subscribedGameIds.remove(id)
        }

        self.view?.showSimpleAlert(
            title: makeSubscriptionTitle(response: response),
            message: makeSubscriptionText(response: response)
        )

        guard let index = games.firstIndex(where: { $0.id == id }) else { return }
        self.view?.changeSubscribeStatus(forGameAt: index)
    }

    func interactor(
        _ interactor: ScheduleInteractorProtocol?,
        failedToSubscribeForGameWith gameId: String,
        error: NetworkServiceError
    ) {
        print(error)
        switch error {
        case .invalidToken:
            view?.showSimpleAlert(
                title: "Не удалось подписаться на уведомления",
                message: "Для получения напоминаний об играх вам необходимо авторизоваться в Личном кабинете"
            )
        default:
            view?.showErrorConnectingToServerAlert()
        }
    }

    func interactor(_ interactor: ScheduleInteractorProtocol?, failedToOpenMapsWithError error: Error) {
        // view?.showSimpleAlert(title: "Не удалось определить адрес для этого места")
    }
}
