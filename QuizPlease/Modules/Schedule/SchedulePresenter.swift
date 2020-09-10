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
    
    var games: [GameInfo]? { get set }
    var scheduleFilter: ScheduleFilter { get set }
    
    func configureViews()
    func didSignUp(forGameAt index: Int)
    func didPressInfoButton(forGameAt index: Int)
    func didAskNotification(forGameAt index: Int)
    func didAskLocation(forGameAt index: Int)
    
    func didPressFilterButton()
    func didChangeScheduleFilter(newFilter: ScheduleFilter)
    
    func handleRefreshControl()
    
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
    
    var games: [GameInfo]?
    
    var scheduleFilter = ScheduleFilter()
    
    func configureViews() {
        view?.configureTableView()
        
        updateSchedule()
    }
    
    //MARK:- Actions
    func didSignUp(forGameAt index: Int) {
        guard let game = games?[index] else { return }
        router.showGameInfo(GameInfoPresentAttributes(game: game, shouldScrollToSignUp: true))
    }
    
    func didPressInfoButton(forGameAt index: Int) {
        guard let game = games?[index] else { return }
        router.showGameInfo(GameInfoPresentAttributes(game: game, shouldScrollToSignUp: false))
    }
    
    func didAskLocation(forGameAt index: Int) {
        guard let game = games?[index] else { return }
        let place = game.placeInfo
        interactor.openInMaps(place: place)
        //interactor.openInMaps(placeName: place.name, withLongitutde: place.longitude, andLatitude: place.latitude)
    }
    
    func didAskNotification(forGameAt index: Int) {
        print("did press notification button")
    }
    
    func didPressFilterButton() {
        router.showScheduleFilters(with: scheduleFilter)
    }
    
    func didChangeScheduleFilter(newFilter: ScheduleFilter) {
        scheduleFilter = newFilter
        updateSchedule()
    }
    
    //MARK:- Handle Refresh Control
    func handleRefreshControl() {
        updateSchedule()
    }
    
    //MARK:- Loading
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
                    self.games?.removeAll()
                    self.view?.reloadScheduleList()
                    self.view?.showNoGamesScheduled()
                }
            case .success(let schedule):
                self.games = schedule
                self.view?.reloadScheduleList()
                for (index, game) in self.games!.enumerated() {
                    self.updateGameInfo(game: game, at: index)
                }
            }
        }
    }
    
    private func updateGameInfo(game: GameInfo, at index: Int) {
        interactor.loadDetailInfo(for: game.id) { [weak self] (fullInfo) in
            guard let self = self else { return }
            if let game = fullInfo {
                self.games?[index] = game
                //self.view?.reloadScheduleList()
                self.view?.reloadGame(at: index)
            }
        }
    }
    
}
