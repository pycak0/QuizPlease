//
//  WarmupPresenter.swift
//  QuizPlease
//
//  Created by Владислав on 04.08.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import Foundation

protocol WarmupPresenterProtocol {
    var router: WarmupRouterProtocol! { get }
    init(view: WarmupViewProtocol, interactor: WarmupInteractorProtocol, router: WarmupRouterProtocol)
    
    func configureViews()
}

class WarmupPresenter: WarmupPresenterProtocol {
    var router: WarmupRouterProtocol!
    var interactor: WarmupInteractorProtocol
    weak var view: WarmupViewProtocol?
    
    required init(view: WarmupViewProtocol, interactor: WarmupInteractorProtocol, router: WarmupRouterProtocol) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
    
    func configureViews() {
        //
    }
    
}
