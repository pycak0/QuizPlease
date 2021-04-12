//
//  SplashScreenPresenter.swift
//  QuizPlease
//
//  Created by Владислав on 12.04.2021.
//  Copyright © 2021 Владислав. All rights reserved.
//

import Foundation

protocol SplashScreenPresenterProtocol {
    var router: SplashScreenRouterProtocol { get }
    init(view: SplashScreenViewProtocol, interactor: SplashScreenInteractorProtocol, router: SplashScreenRouterProtocol)
    
    func viewDidLoad(_ view: SplashScreenViewProtocol)
}

class SplashScreenPresenter: SplashScreenPresenterProtocol {
    weak var view: SplashScreenViewProtocol?
    var interactor: SplashScreenInteractorProtocol
    var router: SplashScreenRouterProtocol
    
    private let timeout = 0.5
    
    required init(view: SplashScreenViewProtocol, interactor: SplashScreenInteractorProtocol, router: SplashScreenRouterProtocol) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
    
    func viewDidLoad(_ view: SplashScreenViewProtocol) {
        DispatchQueue.main.asyncAfter(deadline: .now() + timeout) {
            self.router.showMainMenu()
        }
    }
}
