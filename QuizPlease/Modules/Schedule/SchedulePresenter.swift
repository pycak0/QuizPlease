//
//  SchedulePresenter.swift
//  QuizPlease
//
//  Created by Владислав on 04.08.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import Foundation

//MARK:- Presenter Protocol
protocol SchedulePresenterProtocol: class {
    var router: ScheduleRouterProtocol! { get }
    init(view: ScheduleViewProtocol, interactor: ScheduleInteractorProtocol, router: ScheduleRouterProtocol)
    
    var games: [GameInfo] { get set }
    var scheduleFilter: ScheduleFilter { get set }
    
    func configureViews()
    func didSignUp(forGameAt index: Int)
    func didPressInfoButton(forGameAt index: Int)
    func didAskNotification(forGameAt index: Int)
    func didAskLocation(forGameAt index: Int)
    
    func homeGameAction()
    func warmupAction()
    
    func didPressFilterButton()
    func didChangeScheduleFilter(newFilter: ScheduleFilter)
    
    func handleRefreshControl()
    
    func updateDetailInfoIfNeeded(at index: Int)
    
}

//MARK:- Presenter Implementation
class SchedulePresenter: SchedulePresenterProtocol {
    var router: ScheduleRouterProtocol!
    weak var view: ScheduleViewProtocol?
    var interactor: ScheduleInteractorProtocol!
    
    
    required init(view: ScheduleViewProtocol, interactor: ScheduleInteractorProtocol, router: ScheduleRouterProtocol) {
        self.view = view
        self.router = router
        self.interactor = interactor
    }
    
    var games: [GameInfo] = []
    
    var scheduleFilter = ScheduleFilter()
    
    func configureViews() {
        view?.configure()
        
        updateSchedule()
    }
    
    //MARK:- Actions
    func didSignUp(forGameAt index: Int) {
        let game = games[index]
        router.showGameInfo(GameInfoPresentAttributes(game: game, shouldScrollToSignUp: true))
    }
    
    func didPressInfoButton(forGameAt index: Int) {
        let game = games[index]
        router.showGameInfo(GameInfoPresentAttributes(game: game, shouldScrollToSignUp: false))
    }
    
    func didAskLocation(forGameAt index: Int) {
        let game = games[index]
        let place = game.placeInfo
        interactor.openInMaps(place: place)
        //interactor.openInMaps(placeName: place.name, withLongitutde: place.longitude, andLatitude: place.latitude)
    }
    
    func didAskNotification(forGameAt index: Int) {
        let gameId = "\(games[index].id ?? -1)"
        interactor.getSubscribeStatus(gameId: gameId) { [weak self] (subscibeStatus) in
            guard let self = self else { return }
            if let isSubscribe = subscibeStatus {
                let subscirbeMessage = isSubscribe ? "подписаны на уведомления" : "отписаны от уведомлений"
                let title = isSubscribe ? "Подписка на уведомления" : "Отписка от уведомлений"
                self.view?.showSimpleAlert(title: title,
                                           message: "Вы были успешно \(subscirbeMessage) об игре. Если хотите изменить статус подписки, нажмите на кнопку ещё раз")
            } else {
                self.view?.showErrorConnectingToServerAlert()
            }
        }
    }
    
    func didPressFilterButton() {
        router.showScheduleFilters(with: scheduleFilter)
    }
    
    func didChangeScheduleFilter(newFilter: ScheduleFilter) {
        scheduleFilter = newFilter
        updateSchedule()
    }
    
    func homeGameAction() {
        router.showHomeGame(popCurrent: true)
    }
    
    func warmupAction() {
        router.showWarmup(popCurrent: true)
    }
    
    //MARK:- Handle Refresh Control
    func handleRefreshControl() {
        updateSchedule()
    }
    
    //MARK:- Loading
    func updateDetailInfoIfNeeded(at index: Int) {
        guard index < games.count else { return }
        let game = games[index]
        if game.nameGame == GameInfo.placeholderValue {
            updateDetailInfo(forGameId: game.id, at: index)
        }
    }
    
    private func updateDetailInfo(forGameId id: Int, at index: Int) {
        interactor.loadDetailInfo(for: id) { [weak self] (fullInfo) in
            guard let self = self else { return }
            if let game = fullInfo {
                self.games[index] = game
                //self.view?.reloadScheduleList()
                self.view?.reloadGame(at: index)
            }
        }
    }
    
    private func updateSchedule() {
        interactor.loadSchedule(filter: scheduleFilter) { [weak self] (result) in
            guard let self = self else { return }
            self.view?.endLoadingAnimation()
            switch result {
            case.failure(let error):
                print(error)
                switch error {
                case .other(_), .serverError(_), .invalidUrl:
                    self.view?.showErrorConnectingToServerAlert()
                default:
                    self.games.removeAll()
                    self.view?.reloadScheduleList()
                    self.view?.showNoGamesScheduled()
                }
            case .success(let schedule):
                self.games = schedule
                self.view?.reloadScheduleList()
//                for (index, game) in self.games.enumerated() {
//                    self.updateDetailInfo(forGameId: game.id, at: index)
//                }
            }
        }
    }
    
}
