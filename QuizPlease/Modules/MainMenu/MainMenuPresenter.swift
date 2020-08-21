//
//  MainMenuPresenter.swift
//  QuizPlease
//
//  Created by Владислав on 03.08.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import Foundation

protocol MainMenuPresenterProtocol: class {
    var router: MainMenuRouterProtocol! { get }
    init(view: MainMenuViewProtocol, interactor: MainMenuInteractorProtocol, router: MainMenuRouterProtocol)
    var menuItems: [MenuItemProtocol]? { get set }
    
    func configureViews()
    func didSelectMenuItem(at index: Int)
    func didSelectCityButton()
    func didPressAddGame()
}

class MainMenuPresenter: MainMenuPresenterProtocol {
    weak var view: MainMenuViewProtocol?
    var interactor: MainMenuInteractorProtocol!
    var router: MainMenuRouterProtocol!
    
    var menuItems: [MenuItemProtocol]?
    
    required init(view: MainMenuViewProtocol, interactor: MainMenuInteractorProtocol, router: MainMenuRouterProtocol) {
        self.router = router
        self.view = view
        self.interactor = interactor
    }
    
    func configureViews() {
        view?.configureTableView()
        
        //MARK:- Make sure that interactor clouse is being called on main thread
        interactor.loadMenuItems { result in
            switch result {
            case .failure(let error):
                self.view?.failureLoadingMenuItems(error)
            case .success(let items):
                self.menuItems = items
                self.view?.reloadMenuItems()
            }
        }
    }
    
    func didSelectMenuItem(at index: Int) {
        guard let item = menuItems?[index] else { return }
        router.showMenuSection(item, sender: nil)
    }
    
    func didSelectCityButton() {
        router.showChooseCityScreen()
    }
    
    func didPressAddGame() {
        router.showQRScanner()
    }
    
}
