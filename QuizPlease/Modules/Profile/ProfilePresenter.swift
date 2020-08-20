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
    
    func configureViews()
}

class ProfilePresenter: ProfilePresenterProtocol {
    var router: ProfileRouterProtocol!
    var interactor: ProfileInteractorProtocol
    weak var view: ProfileViewProtocol?
    
    required init(view: ProfileViewProtocol, interactor: ProfileInteractorProtocol, router: ProfileRouterProtocol) {
        self.view = view
        self.router = router
        self.interactor = interactor
    }
    
    func configureViews() {
        view?.configureTableView()
    }
}
