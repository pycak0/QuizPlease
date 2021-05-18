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
    
    func viewDidLoad(_ view: ProfileViewProtocol)
    func handleViewDidAppear()
    
    func didPerformAuth()
    func didPressExitButton()
    
    func didPressShowShopButton()
    func didPressAddGameButton()
    func didScanQrCode(with info: String)
    func didAddNewGame()
}

class ProfilePresenter: ProfilePresenterProtocol {
    var router: ProfileRouterProtocol!
    var interactor: ProfileInteractorProtocol
    weak var view: ProfileViewProtocol?
    
    var userInfo: UserInfo?
    
    private var isFirstAppear = true
    
    required init(view: ProfileViewProtocol, interactor: ProfileInteractorProtocol, router: ProfileRouterProtocol) {
        self.view = view
        self.router = router
        self.interactor = interactor
    }
    
    //MARK:- View Did Load
    func viewDidLoad(_ view: ProfileViewProtocol) {
        view.configure()
        view.setCity(AppSettings.defaultCity.title)
        
        if AppSettings.userToken == nil {
            router.showAuthScreen()
        } else {
            interactor.loadUserInfo()
        }
    }
    
    func handleViewDidAppear() {
        //nothing for now
    }
    
    func didPerformAuth() {
        interactor.loadUserInfo()
    }
    
    //MARK:- Actions
    func didPressExitButton() {
        view?.showTwoOptionsAlert(title: "Вы уверены, что хотите выйти из личного кабинета?", message: "", option1Title: "Да", handler1: { _ in
            self.interactor.deleteUserInfo()
            self.router.closeProfile()
        }, option2Title: "Отмена", handler2: nil)
    }
    
    func didPressShowShopButton() {
        router.showShop(with: userInfo)
    }
    
    func didPressAddGameButton() {
        router.showQRScanner()
    }
    
    func didScanQrCode(with info: String) {
        router.showAddGameScreen(info)
    }
    
    func didAddNewGame() {
        interactor.loadUserInfo()
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
