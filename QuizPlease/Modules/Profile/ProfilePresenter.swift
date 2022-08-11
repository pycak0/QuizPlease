//
//  ProfilePresenter.swift
//  QuizPlease
//
//  Created by Владислав on 04.08.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import UIKit

// MARK: - Presenter Protocol
protocol ProfilePresenterProtocol {
    var router: ProfileRouterProtocol! { get }
    init(view: ProfileViewProtocol, interactor: ProfileInteractorProtocol, router: ProfileRouterProtocol)

    var userInfo: UserInfo? { get set }

    func viewDidLoad(_ view: ProfileViewProtocol)
    func handleViewDidAppear()

    func didPerformAuth()
    func didPressOptionsButton()

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

    // MARK: - View Did Load
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
        // nothing for now
    }

    func didPerformAuth() {
        interactor.loadUserInfo()
    }

    // MARK: - Actions
    func didPressOptionsButton() {
        view?.showExitOrDeleteActionSheet(onExit: exit, onDelete: deleteAccount)
    }

    private func exit() {
        view?.showExitAlert(onConfirm: { [weak self] in
            self?.logOutAndClose()
        })
    }

    private func deleteAccount() {
        view?.showDeleteAccountAlert(onConfirm: { [weak self] in
            self?.interactor.deleteUserAccount()
        })
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

    private func logOutAndClose() {
        interactor.logOut()
        router.closeProfile()
    }
}

// MARK: - Interactor Delegate
extension ProfilePresenter: ProfileInteractorDelegate {

    func didFailLoadingUserInfo(with error: NetworkServiceError) {
        view?.showErrorConnectingToServerAlert()
    }

    func didSuccessfullyLoadUserInfo(_ userInfo: UserInfo) {
        print(userInfo)
        self.userInfo = userInfo
        updateUserInfo()
    }

    func didSuccessfullyDeleteAccount() {
        logOutAndClose()
    }

    func didFailDeletingAccount(with error: NetworkServiceError) {
        view?.showErrorConnectingToServerAlert(title: "Произошла ошибка")
    }
}
