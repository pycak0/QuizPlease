//
//  ProfilePresenter.swift
//  QuizPlease
//
//  Created by Владислав on 04.08.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import Foundation

//MARK:- Presenter Protocol
protocol ProfilePresenterProtocol {
    var router: ProfileRouterProtocol! { get }
    init(view: ProfileViewProtocol, interactor: ProfileInteractorProtocol, router: ProfileRouterProtocol)
    
    var userInfo: UserInfo? { get set }
    
    func setupView()
    
    func didPerformAuth()
    
    func didPressShowShopButton()
    func didPressAddGameButton()
    func didAddNewGame(with info: String)
}

class ProfilePresenter: ProfilePresenterProtocol {
    var router: ProfileRouterProtocol!
    var interactor: ProfileInteractorProtocol
    weak var view: ProfileViewProtocol?
    
    var userInfo: UserInfo?
    
    required init(view: ProfileViewProtocol, interactor: ProfileInteractorProtocol, router: ProfileRouterProtocol) {
        self.view = view
        self.router = router
        self.interactor = interactor
    }
    
    //MARK:- Setup View
    func setupView() {
        view?.configureViews()
        
        if Globals.userToken == nil {
            router.showAuthScreen()
        } else {
            if userInfo != nil {
                updateUserInfo()
            } else {
                interactor.loadUserInfo()
            }
        }
    }
    
    func didPerformAuth() {
        interactor.loadUserInfo()
    }
    
    //MARK:- Actions
    func didPressShowShopButton() {
        router.showShop(with: userInfo)
    }
    
    func didPressAddGameButton() {
        router.showQRScanner()
    }
    
    func didAddNewGame(with info: String) {
        router.showAddGameScreen(info)
    }
    
    private func updateUserInfo() {
        guard let info = userInfo else { return }
        view?.reloadGames()
        view?.updateUserInfo(with: info.pointsAmount)
    }
}

//MARK:- Interactor Delegate
extension ProfilePresenter: ProfileInteractorDelegate {
    func didFailLoadingUserInfo(with error: SessionError) {
        view?.showErrorConnectingToServerAlert()
    }
    
    func didSuccessfullyLoadUserInfo(_ userInfo: UserInfo) {
        print(userInfo)
        self.userInfo = userInfo
        updateUserInfo()
    }
}
