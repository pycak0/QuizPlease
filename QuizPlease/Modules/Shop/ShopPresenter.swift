//
//  ShopPresenter.swift
//  QuizPlease
//
//  Created by Владислав on 05.08.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import Foundation

protocol ShopPresenterProtocol {
    var router: ShopRouterProtocol! { get }
    init(view: ShopViewProtocol, interactor: ShopInteractorProtocol, router: ShopRouterProtocol)
    
    var items: [ShopItem] { get set }
    
    func configureViews()
    
    func handleRefreshControl(completion: (() -> Void)?)
}

class ShopPresenter: ShopPresenterProtocol {
    var router: ShopRouterProtocol!
    var interactor: ShopInteractorProtocol
    weak var view: ShopViewProtocol?
    
    var items: [ShopItem] = []
    
    required init(view: ShopViewProtocol, interactor: ShopInteractorProtocol, router: ShopRouterProtocol) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
    
    
    func configureViews() {
        view?.configureCollectionView()
        
        reloadItems()
    }
    
    func handleRefreshControl(completion: (() -> Void)?) {
        reloadItems(completion)
    }
    
    private func reloadItems(_ completion: (() -> Void)? = nil) {
        interactor.loadItems { [weak self] (result) in
            completion?()
            guard let self = self else { return }
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
    
}
