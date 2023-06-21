//
//  MainMenuPresenter.swift
//  QuizPlease
//
//  Created by Владислав on 03.08.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import Foundation
import UIKit

// MARK: - Presenter Protocol

protocol MainMenuPresenterProtocol: AnyObject {

    var router: MainMenuRouterProtocol! { get }
    var menuItems: [MainMenuItemProtocol]? { get set }
    var sampleShopItems: [ShopItem] { get }

    init(view: MainMenuViewProtocol, interactor: MainMenuInteractorProtocol, router: MainMenuRouterProtocol)

    func viewDidLoad(_ view: MainMenuViewProtocol)
    func viewDidAppear(_ view: MainMenuViewProtocol)

    func didSelectMenuItem(at index: Int)
    func didSelectCityButton()
    func didChangeDefaultCity(_ newCity: City)
    func didPressAddGame()
    func didAddNewGame(with info: String)
    func didPressMenuRemindButton()
    func didLongTapOnLogo()

    func userPointsAmount() -> Double?
    func indexPath(for menuItemKind: MainMenuItemKind) -> IndexPath?
}

final class MainMenuPresenter: MainMenuPresenterProtocol {

    weak var view: MainMenuViewProtocol?
    var interactor: MainMenuInteractorProtocol!
    var router: MainMenuRouterProtocol!

    var menuItems: [MainMenuItemProtocol]?
    var sampleShopItems: [ShopItem] = []
    var userInfo: UserInfo?

    required init(view: MainMenuViewProtocol, interactor: MainMenuInteractorProtocol, router: MainMenuRouterProtocol) {
        self.router = router
        self.view = view
        self.interactor = interactor
    }

    func viewDidLoad(_ view: MainMenuViewProtocol) {
        interactor.requestForPushNotifications()
        view.configureTableView()
        view.updateCityName(with: AppSettings.defaultCity.title)
        interactor.loadMenuItems()
        interactor.postMainScreenLoaded()
    }

    func viewDidAppear(_ view: MainMenuViewProtocol) {
        interactor.loadUserInfo()
        if sampleShopItems.count == 0 || sampleShopItems.first?.title == "SAMPLE" {
            interactor.loadShopItems()
        }
    }

    // MARK: - Actions

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
        router.showChooseCityScreen(selectedCity: AppSettings.defaultCity)
    }

    func didChangeDefaultCity(_ newCity: City) {
        AppSettings.defaultCity = newCity
        view?.updateCityName(with: newCity.title)
        interactor.updateAllData()
    }

    func didPressAddGame() {
        if AppSettings.userToken != nil {
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

    func didLongTapOnLogo() {
        router.showDebugMenu()
    }

    func userPointsAmount() -> Double? {
        userInfo?.pointsAmount
    }

    func indexPath(for menuItemKind: MainMenuItemKind) -> IndexPath? {
        if let index = menuItems?.firstIndex(where: { $0._kind == menuItemKind }) {
            return IndexPath(row: index, section: 0)
        }
        return nil
    }
}

// MARK: - MainMenuInteractorOutput

extension MainMenuPresenter: MainMenuInteractorOutput {
    func interactor(_ interactor: MainMenuInteractorProtocol, didLoadMenuItems items: [MainMenuItemProtocol]) {
        menuItems = items
        view?.reloadMenuItems()
    }

    func interactor(_ interactor: MainMenuInteractorProtocol, didLoadUserInfo userInfo: UserInfo) {
        self.userInfo = userInfo
        view?.reloadUserPointsAmount()
    }

    func interactor(_ interactor: MainMenuInteractorProtocol, didLoadShopItems shopItems: [ShopItem]) {
        sampleShopItems = shopItems
        view?.reloadShopItems()
    }

    func interactor(
        _ interactor: MainMenuInteractorProtocol,
        failedToLoadShopItemsWithError error: NetworkServiceError
    ) {
        print(error)
    }

    func interactor(
        _ interactor: MainMenuInteractorProtocol,
        failedToLoadMenuItemsWithError error: NetworkServiceError
    ) {
        view?.failureLoadingMenuItems(error)
    }

    func interactor(
        _ interactor: MainMenuInteractorProtocol,
        failedToLoadUserInfoWithError error: NetworkServiceError
    ) {
        print(error)
        switch error {
        case .invalidToken:
            userInfo = nil
            view?.reloadUserPointsAmount()
        default:
            break
        }
    }
}
