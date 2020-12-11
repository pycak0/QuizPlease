//
//  GameOrderInteractor.swift
//  QuizPlease
//
//  Created by Владислав on 13.08.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import Foundation
import SafariServices

//MARK:- Interactor Protocol
protocol GameOrderInteractorProtocol {
    func register(with form: RegisterForm, completion: @escaping (_ orderResponse: GameOrderResponse?) -> Void)
    
    func checkCertificate(forGameId id: Int, certificate: String, completion: @escaping (Result<CertificateResponse, SessionError>) -> Void)
}

class GameOrderInteractor: GameOrderInteractorProtocol {
    func register(with form: RegisterForm, completion: @escaping (_ orderResponse: GameOrderResponse?) -> Void) {
        NetworkService.shared.registerOnGame(registerForm: form) { serverResponse in
            switch serverResponse {
            case let .failure(error):
                print(error)
                completion(nil)
            case let .success(response):
                completion(response)
            }
        }
    }
    
    func checkCertificate(forGameId id: Int, certificate: String, completion: @escaping (Result<CertificateResponse, SessionError>) -> Void) {
        NetworkService.shared.validateCertificate(forGameWithId: id, certificate: certificate, completion: completion)
    }
}
