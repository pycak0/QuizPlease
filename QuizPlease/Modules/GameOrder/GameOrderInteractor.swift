//
//  GameOrderInteractor.swift
//  QuizPlease
//
//  Created by Владислав on 13.08.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import Foundation

protocol GameOrderInteractorProtocol {
    func register(with form: RegisterForm, completion: @escaping (_ orderResponse: GameOrderResponse?) -> Void)
}

class GameOrderInteractor: GameOrderInteractorProtocol {
    func register(with form: RegisterForm, completion: @escaping (_ orderResponse: GameOrderResponse?) -> Void) {
        NetworkService.shared.registerOnGame(registerForm: form, completion: completion)
    }
}
