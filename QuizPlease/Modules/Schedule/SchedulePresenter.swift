//
//  SchedulePresenter.swift
//  QuizPlease
//
//  Created by Владислав on 04.08.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import Foundation

protocol SchedulePresenterProtocol: class {
    var router: ScheduleRouterProtocol! { get }
    init(view: ScheduleViewProtocol, interactor: ScheduleInteractorProtocol, router: ScheduleRouterProtocol)
    
    var games: [GameInfo]? { get set }
    
    func configureViews()
    func didSignUp(forGameAt index: Int)
    func didPressInfoButton(forGameAt index: Int)
    func didAskNotification(forGameAt index: Int)
    
    //MARK:- Need to Create a data structure for filters
    func didChangeScheduleFilter(newFilter: Any?)
    
}

class SchedulePresenter: SchedulePresenterProtocol {
    var router: ScheduleRouterProtocol!
    weak var view: ScheduleViewProtocol?
    var interactor: ScheduleInteractorProtocol!
    
    
    required init(view: ScheduleViewProtocol, interactor: ScheduleInteractorProtocol, router: ScheduleRouterProtocol) {
        self.view = view
        self.router = router
        self.interactor = interactor
    }
    
    var games: [GameInfo]?
    
    func configureViews() {
        print("SchedulePresenter's configureViews() is not implemented")
    }
    
    func didSignUp(forGameAt index: Int) {
        print("did press sign up button")
    }
    
    func didPressInfoButton(forGameAt index: Int) {
        print("did press info button")
    }
    
    func didAskNotification(forGameAt index: Int) {
        print("did press notification button")
    }
    
    func didChangeScheduleFilter(newFilter: Any?) {
        print("did change filter")
    }
    
}
