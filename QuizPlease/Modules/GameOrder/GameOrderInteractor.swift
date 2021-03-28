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
    ///must be weak
    var output: GameOrderInteractorOutput? { get }
    
    func register(with form: RegisterForm, completion: @escaping (_ orderResponse: GameOrderResponse?) -> Void)
    
    func checkCertificate(forGameId id: Int, certificate: String, completion: @escaping (Result<CertificateResponse, SessionError>) -> Void)
    func checkPromocode(_ promocode: String, forGameWithId id: Int)
}

//MARK:- Output Protocol
protocol GameOrderInteractorOutput: class {
    func interactor(_ interactor: GameOrderInteractorProtocol?, didCheckPromocodeWith response: PromocodeResponse)
    func interactor(_ interactor: GameOrderInteractorProtocol?, errorOccured error: SessionError)
}

//MARK:- Implementation
class GameOrderInteractor: GameOrderInteractorProtocol {
    weak var output: GameOrderInteractorOutput?
    
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
    
    func checkPromocode(_ promocode: String, forGameWithId id: Int) {
        let path = "/ajax/check-promo"
        let params = [
            "game_id": "\(id)",
            "code": promocode
        ]
        NetworkService.shared.get(PromocodeResponse.self, apiPath: path, parameters: params) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .failure(error):
                self.output?.interactor(self, errorOccured: error)
            case let .success(response):
                self.output?.interactor(self, didCheckPromocodeWith: response)
            }
        }
    }
}
