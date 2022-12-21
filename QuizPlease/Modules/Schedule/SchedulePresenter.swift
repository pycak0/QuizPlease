//
//  SchedulePresenter.swift
//  QuizPlease
//
//  Created by Владислав on 04.08.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import Foundation

// MARK: - Presenter Protocol
protocol SchedulePresenterProtocol: AnyObject {

    var router: ScheduleRouterProtocol { get }

    var gamesCount: Int { get }
    var scheduleFilter: ScheduleFilter { get set }

    func viewDidLoad(_ view: ScheduleViewProtocol)
    func didSignUp(forGameAt index: Int)
    func didPressInfoButton(forGameAt index: Int)
    func didAskNotification(forGameAt index: Int)
    func didAskLocation(forGameAt index: Int)

    func homeGameAction()
    func warmupAction()

    func didPressFilterButton()
    func didChangeScheduleFilter(newFilter: ScheduleFilter)
    func didPressScheduleRemindButton()

    func handleRefreshControl()
    func updateDetailInfoIfNeeded(at index: Int)

    func viewModel(forGameAt index: Int) -> ScheduleGameCellViewModel
}

// MARK: - Presenter Implementation

final class SchedulePresenter: SchedulePresenterProtocol {

    weak var view: ScheduleViewProtocol?

    let interactor: ScheduleInteractorProtocol
    let router: ScheduleRouterProtocol
    let analyticsService: AnalyticsService

    private var games: [GameInfo] = []

    var gamesCount: Int {
        games.count
    }

    var scheduleFilter = ScheduleFilter()

    private var subscribedGameIds = [Int]()

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
        view.startLoading()
        updateSchedule()
        analyticsService.sendEvent(.scheduleOpen)
    }

    func viewModel(forGameAt index: Int) -> ScheduleGameCellViewModel {
        let game = games[index]
        let isSubscribed = isSubscribedOnGame(with: game.id)

        let subscribeButtonModel = SubscribeButtonViewModel(
            isPresented: AppSettings.isProfileEnabled,
            tintColor: isSubscribed ? .black : .white,
            backgroundColor: isSubscribed ? .lemon : .themePurple,
            title: isSubscribed ? "Напомним" : "Напомнить"
        )

        return ScheduleGameCellViewModel(
            gameInfo: game,
            subscribeButtonViewModel: subscribeButtonModel
        )
    }

    private func isSubscribedOnGame(with id: Int) -> Bool {
        return subscribedGameIds.contains(id)
    }

    // MARK: - Actions

    func didSignUp(forGameAt index: Int) {
        router.showGameInfo(
            with: gameOrderPresentationOptions(gameIndex: index, scrollToSignUp: true)
        )
    }

    func didPressInfoButton(forGameAt index: Int) {
        let game = games[index]
        let statusesAllowedForTransition = [GameStatus.placesAvailable, .reserveAvailable, .fewPlaces]

        guard
            let status = game.gameStatus,
            statusesAllowedForTransition.contains(status)
        else {
            return
        }

        router.showGameInfo(
            with: gameOrderPresentationOptions(gameIndex: index, scrollToSignUp: false)
        )
    }

    func didAskLocation(forGameAt index: Int) {
        let game = games[index]
        let place = game.placeInfo
        router.showMap(for: place)
    }

    func didAskNotification(forGameAt index: Int) {
        let id = games[index].id ?? -1
        let gameId = "\(id)"
        interactor.getSubscribeStatus(gameId: gameId)
    }

    func didPressFilterButton() {
        router.showScheduleFilters(with: scheduleFilter)
    }

    func didChangeScheduleFilter(newFilter: ScheduleFilter) {
        scheduleFilter = newFilter
        updateSchedule()
    }

    func didPressScheduleRemindButton() {
        //
    }

    func homeGameAction() {
        router.showHomeGame(popCurrent: true)
    }

    func warmupAction() {
        router.showWarmup(popCurrent: true)
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
        loadSchedule()
        updateSubscribedGames()
    }

    private func loadSchedule() {
        interactor.loadSchedule(filter: scheduleFilter) { [weak self] (result) in
            guard let self = self else { return }
            self.view?.stopLoading()
            switch result {
            case.failure(let error):
                print(error)
                switch error {
                case .other, .serverError, .invalidUrl:
                    self.view?.showErrorConnectingToServerAlert()
                default:
                    self.games.removeAll()
                    self.view?.reloadScheduleList()
                    self.view?.showNoGamesScheduled()
                }
            case .success(let schedule):
                self.games = schedule
                self.view?.reloadScheduleList()
            }
        }
    }

    private func updateSubscribedGames() {
        interactor.getSubscribedGameIds { [weak self] (gameIds) in
            guard let self = self else { return }
            self.subscribedGameIds = gameIds
        }
    }

    private func gameOrderPresentationOptions(
        gameIndex: Int,
        scrollToSignUp: Bool
    ) -> GameOrderPresentationOptions {
        let game = games[gameIndex]
        return GameOrderPresentationOptions(
            gameInfo: game,
            cityId: scheduleFilter.city.id,
            shouldScrollToSignUp: scrollToSignUp,
            shouldLoadGameInfo: false
        )
    }
}

// MARK: - ScheduleInteractorOutput

extension SchedulePresenter: ScheduleInteractorOutput {

    func interactor(
        _ interactor: ScheduleInteractorProtocol?,
        didGetSubscribeStatus isSubscribed: Bool,
        forGameWithId id: String
    ) {
        let title = isSubscribed ? "Мы напомним об игре" : "Отписка от уведомлений"
        let message = isSubscribed
            ? "За два дня до начала или когда места для регистрации начнут заканчиваться"
            : "Вы были успешно отписаны от уведомлений об игре. " +
        "Если хотите снова подписаться, нажмите на кнопку еще раз"

        self.view?.showSimpleAlert(
            title: title,
            message: message
        )

        guard let id = Int(id), let index = games.firstIndex(where: { $0.id == id }) else { return }
        if isSubscribed {
            self.subscribedGameIds.append(id)
        } else {
            self.subscribedGameIds.removeAll { $0 == id }
        }
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
                message: "Для получения напоминаний об играх Вам необходимо авторизоваться в Личном кабинете"
            )
        default:
            view?.showErrorConnectingToServerAlert()
        }
    }

    func interactor(_ interactor: ScheduleInteractorProtocol?, failedToOpenMapsWithError error: Error) {
        // view?.showSimpleAlert(title: "Не удалось определить адрес для этого места")
    }
}
