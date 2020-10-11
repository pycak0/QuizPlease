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
    
    func setupView()
    
    func didSelectItem(at index: Int)
    func didAgreeToPurchase(_ item: ShopItem)
    func handleRefreshControl()
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
    func setupView() {
        view?.configureCollectionView()
        reloadItems()

        if let info = userInfo {
            view?.showUserPoints(info.pointsAmount)
        } else {
            loadUserInfo()
        }
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
            self.view?.endLoadingAnimation()
            switch result {
            case .failure(let error):
                print(error)
                self.view?.showErrorConnectingToServerAlert()
            case .success(let items):
                self.items = items
                self.view?.reloadCollectionView()
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
    
    func didAgreeToPurchase(_ item: ShopItem) {
//        if let info = userInfo {
//            if info.pointsAmount >= item.priceNumber {
//                router.showCompletionScreen(for: item)
//            } else {
//                let diff = (item.priceNumber - info.pointsAmount).string(withAssociatedMaleWord: "балл")
//                view?.showSimpleAlert(
//                    title: "Недостаточно баллов",
//                    message: "Для приобретения этого продукта Вам не хватает \(diff)")
//            }
//        } else {
//            view?.showSimpleAlert(title: "Для совершения покупок необходимо авторизоваться",
//                                  message: "Вы можете авторизоваться или зарегистрироваться в Личном кабинете")
//        }
        router.showCompletionScreen(for: item)
    }
    
}
