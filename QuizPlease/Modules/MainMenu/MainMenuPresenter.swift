//
//  MainMenuPresenter.swift
//  QuizPlease
//
//  Created by Владислав on 03.08.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import Foundation

//MARK:- Presenter Protocol
protocol MainMenuPresenterProtocol: class {
    var router: MainMenuRouterProtocol! { get }
    init(view: MainMenuViewProtocol, interactor: MainMenuInteractorProtocol, router: MainMenuRouterProtocol)
    var menuItems: [MenuItemProtocol]? { get set }
    
    var sampleShopItems: [ShopItem] { get }
    
    func setupView()
    func didSelectMenuItem(at index: Int)
    func didSelectCityButton()
    func didChangeDefaultCity(_ newCity: City)
    func didPressAddGame()
    func didAddNewGame(with info: String)
    func didPressMenuRemindButton()
    
    func handleViewDidAppear()
}

class MainMenuPresenter: MainMenuPresenterProtocol {
    weak var view: MainMenuViewProtocol?
    var interactor: MainMenuInteractorProtocol!
    var router: MainMenuRouterProtocol!
    
    var menuItems: [MenuItemProtocol]?
    
    var sampleShopItems: [ShopItem] = []
    
    var userInfo: UserInfo?
    
    required init(view: MainMenuViewProtocol, interactor: MainMenuInteractorProtocol, router: MainMenuRouterProtocol) {
        self.router = router
        self.view = view
        self.interactor = interactor
    }
    
    func setupView() {
        view?.configureTableView()
        view?.updateCityName(with: Globals.defaultCity.title)
        
        interactor.loadMenuItems { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .failure(let error):
                self.view?.failureLoadingMenuItems(error)
            case .success(let items):
                self.menuItems = items
                self.view?.reloadMenuItems()
            }
        }
    }
    
    func handleViewDidAppear() {
        if Globals.userToken != nil {
            loadUserInfo()
        }
        
        if sampleShopItems.count == 0 || sampleShopItems.first?.title == "SAMPLE" {
            reloadShopItems()
        }
    }
    
    //MARK:- Load User Info
    func loadUserInfo() {
        interactor.loadUserInfo { [weak self] (serverResult) in
            guard let self = self else { return }
            switch serverResult {
            case let .failure(error):
                print(error)
            case let .success(userInfo):
                self.userInfo = userInfo
                self.view?.updateUserPointsAmount(with: userInfo.pointsAmount)
                
            }
        }
    }
    
    //MARK:- Actions
    func didSelectMenuItem(at index: Int) {
        guard let item = menuItems?[index] else { return }
        var sender: UserInfo?
        switch item._kind {
        case .profile, .shop:
            sender = userInfo
        default:
            break
        }
        router.showMenuSection(item, sender: sender)
    }
    
    func didSelectCityButton() {
        router.showChooseCityScreen(Globals.defaultCity)
    }
    
    func didChangeDefaultCity(_ newCity: City) {
        Globals.defaultCity = newCity
        view?.updateCityName(with: newCity.title)
        reloadShopItems()
    }
    
    func didPressAddGame() {
        if Globals.userToken != nil {
            router.showQRScanner()
        } else {
            if let item = menuItems?.first(where: { $0._kind == .profile }) {
                router.showMenuSection(item, sender: userInfo)
            }
        }
        
    }
    
    func didAddNewGame(with info: String) {
        router.showAddGameScreen(info)
    }
    
    func didPressMenuRemindButton() {
        //
    }
    
    private func reloadShopItems() {
        interactor.loadShopItems { [weak self] (items) in
            guard let self = self else { return }
            self.sampleShopItems = items
            self.view?.reloadShopItems()
        }
    }
    
}
