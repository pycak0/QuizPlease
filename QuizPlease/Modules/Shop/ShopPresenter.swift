//
//  ShopPresenter.swift
//  QuizPlease
//
//  Created by Владислав on 05.08.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import Foundation

//MARK:- Presenter Protocol
protocol ShopPresenterProtocol {
    var router: ShopRouterProtocol! { get }
    init(view: ShopViewProtocol, interactor: ShopInteractorProtocol, router: ShopRouterProtocol)
    
    var items: [ShopItem] { get set }
    
    var userInfo: UserInfo? { get set }
    
    func viewDidLoad(_ view: ShopViewProtocol)
    
    func didSelectItem(at index: Int)
    func didAgreeToPurchase(_ item: ShopItem)
    func didPurchase(_ item: ShopItem)
    func handleRefreshControl()
    
    func didPressRemindButton()
}

class ShopPresenter: ShopPresenterProtocol {
    var router: ShopRouterProtocol!
    var interactor: ShopInteractorProtocol
    weak var view: ShopViewProtocol?
    
    var userInfo: UserInfo?
    
    var items: [ShopItem] = []
    
    required init(view: ShopViewProtocol, interactor: ShopInteractorProtocol, router: ShopRouterProtocol) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
    
    //MARK:- Setup View
    func viewDidLoad(_ view: ShopViewProtocol) {
        view.configure()
        reloadItems()
        view.startLoading()

        if let info = userInfo {
            view.showUserPoints(info.pointsAmount)
        }
        loadUserInfo()
    }
    
    //MARK:- Refresh Control
    func handleRefreshControl() {
        reloadItems()
        loadUserInfo()
    }
    
    //MARK:- Reload Items
    private func reloadItems() {
        interactor.loadItems { [weak self] (result) in
            guard let self = self else { return }
            self.view?.stopLoading()
            switch result {
            case .failure(let error):
                print(error)
                self.view?.showErrorConnectingToServerAlert()
            case .success(let items):
                self.items = items
                if items.isEmpty {
                    self.view?.showItemsEmpty()
                } else {
                    self.view?.reloadCollectionView()
                }
            }
        }
    }
    
    //MARK:- Load User Info
    private func loadUserInfo() {
        interactor.loadUserInfo { [weak self] (serverResult) in
            guard let self = self else { return }
            switch serverResult {
            case let .failure(error):
                print(error)
            case let .success(userInfo):
                self.userInfo = userInfo
                self.view?.showUserPoints(userInfo.pointsAmount)
            }
        }
    }
    
    //MARK:- Actions
    func didSelectItem(at index: Int) {
        let item = items[index]
        router.showConfirmScreen(for: item)
    }
    
    func didPressRemindButton() {
        //
    }
    
    func didAgreeToPurchase(_ item: ShopItem) {
        guard let user = userInfo else {
            view?.showNeedsAuthAlert(title: "Для совершения покупок необходимо авторизоваться")
            return
        }
        guard canUser(user, buyItem: item) else {
            let diff = (item.priceNumber - user.pointsAmount).string(withAssociatedMaleWord: "балл")
            view?.showSimpleAlert(
                title: "Недостаточно баллов",
                message: "Для приобретения этого продукта Вам не хватает \(diff)"
            )
            return
        }
        router.showCompletionScreen(for: item)
    }
    
    func didPurchase(_ item: ShopItem) {
        loadUserInfo()
    }

    private func canUser(_ user: UserInfo, buyItem item: ShopItem) -> Bool {
        return user.pointsAmount >= item.priceNumber
    }
}
