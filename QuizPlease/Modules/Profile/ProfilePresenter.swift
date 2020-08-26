//
//  ProfilePresenter.swift
//  QuizPlease
//
//  Created by Владислав on 04.08.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import Foundation

protocol ProfilePresenterProtocol {
    var router: ProfileRouterProtocol! { get }
    init(view: ProfileViewProtocol, interactor: ProfileInteractorProtocol, router: ProfileRouterProtocol)
    var games: [Any?] { get set }
    
    func configureViews()
    
    func didPressShowShopButton()
    func didPressAddGameButton()
    func didAddNewGame(with info: String)
}

class ProfilePresenter: ProfilePresenterProtocol {
    var router: ProfileRouterProtocol!
    var interactor: ProfileInteractorProtocol
    weak var view: ProfileViewProtocol?
    
    var games: [Any?] = []
    
    required init(view: ProfileViewProtocol, interactor: ProfileInteractorProtocol, router: ProfileRouterProtocol) {
        self.view = view
        self.router = router
        self.interactor = interactor
    }
    
    func configureViews() {
        view?.configureViews()
    }
    
    func didPressShowShopButton() {
        router.showShop()
    }
    
    func didPressAddGameButton() {
        router.showQRScanner()
    }
    
    func didAddNewGame(with info: String) {
        router.showAddGameScreen(info)
    }
}
