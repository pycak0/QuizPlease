//
//  GameOrderPresenter.swift
//  QuizPlease
//
//  Created by Владислав on 13.08.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import Foundation

//MARK:- Presenter Protocol
protocol GameOrderPresenterProtocol {
    var game: GameInfo! { get set }
    var registerForm: RegisterForm { get set }
    
    var router: GameOrderRouterProtocol! { get }
    init(view: GameOrderViewProtocol, interactor: GameOrderInteractorProtocol, router: GameOrderRouterProtocol)
    
    func configureViews()
    
    func didPressSubmitButton()
}

class GameOrderPresenter: GameOrderPresenterProtocol {
    weak var view: GameOrderViewProtocol?
    var interactor: GameOrderInteractorProtocol!
    var router: GameOrderRouterProtocol!
    
    var registerForm = RegisterForm()
    var game: GameInfo! {
        didSet {
            registerForm.gameId = game.id
            registerForm.paymentType = game.availablePaymentTypes.contains(.online) ? .online : .cash
        }
    }

    required init(view: GameOrderViewProtocol, interactor: GameOrderInteractorProtocol, router: GameOrderRouterProtocol) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
    
    func configureViews() {
        view?.configureTableView()
    }
    
    //MARK:- Submit Button Action
    func didPressSubmitButton() {
        guard registerForm.isValid else {
            view?.showSimpleAlert(title: "Заполнены не все необходимые поля",
                                  message: "Пожалуйста, введите нужные данные и проверьте их правильность")
            return
        }
        
        register()
        
    }
    
    //MARK:- Register
    private func register() {
        interactor.register(with: registerForm) { [weak self] (registerResponse) in
            guard let self = self else { return }
            guard let response = registerResponse else {
                self.view?.showErrorConnectingToServerAlert()
                return
            }
            
            let title = "Запись на игру"
            var message: String?
            if response.isSuccess {
                message = response.successMsg
            } else {
                message = response.successMsg ?? response.errorMsg ?? "Произошла ошибка при записи на игру"
            }
            
            if message != nil {
                self.view?.showSimpleAlert(title: title, message: message!)
            } else {
                self.router.showCompletionScreen(with: self.game, numberOfPeopleInTeam: self.registerForm.count)
            }
            
        }
    }
    
}
