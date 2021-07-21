//
//  GameOrderInteractor.swift
//  QuizPlease
//
//  Created by Владислав on 13.08.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import Foundation
import YooKassaPayments

//MARK:- Interactor Protocol
protocol GameOrderInteractorProtocol {
    ///must be weak
    var output: GameOrderInteractorOutput? { get }
    
    func register(with form: RegisterForm, specialConditions: [SpecialCondition], paymentMethod: PaymentMethodType?)
    func checkSpecialCondition(_ value: String, forGameWithId id: Int, selectedTeamName name: String)
}

//MARK:- Output Protocol
protocol GameOrderInteractorOutput: AnyObject {
    func interactor(_ interactor: GameOrderInteractorProtocol?, errorOccured error: NetworkServiceError)
    func interactor(_ interactor: GameOrderInteractorProtocol?, didCheckSpecialCondition value: String, with response: SpecialCondition.Response)
    func interactor(_ interactor: GameOrderInteractorProtocol?, didRegisterWithResponse: GameOrderResponse, paymentMethod: PaymentMethodType?)
}

//MARK:- Implementation
class GameOrderInteractor: GameOrderInteractorProtocol {
    weak var output: GameOrderInteractorOutput?
    
    func register(with registerForm: RegisterForm, specialConditions: [SpecialCondition], paymentMethod: PaymentMethodType?) {
        let certificates: [MultipartFormDataObject] = specialConditions
            .lazy
            .filter { $0.discountInfo?.kind == .certificate }
            .compactMap { MultipartFormDataObject(name: "certificates[]", optionalStringData: $0.value) }

        let promocode = specialConditions.first(where: { $0.discountInfo?.kind == .promocode })?.value
        
        let params: [String: String?] = [
            "QpRecord[registration_type]":  "2", //2 - регистрация через мобильное приложение
            "QpRecord[captainName]":        registerForm.captainName,
            "QpRecord[email]":              registerForm.email,
            "QpRecord[phone]":              registerForm.phone,
            "QpRecord[comment]":            registerForm.comment ?? "",
            "QpRecord[game_id]":            "\(registerForm.gameId)",
            "QpRecord[first_time]":         registerForm.isFirstTime ? "1" : "0",
            "QpRecord[payment_type]":       "\(registerForm.paymentType.rawValue)",
            "QpRecord[count]":              "\(registerForm.count)",
            "QpRecord[teamName]":           registerForm.teamName,
            "QpRecord[payment_token]":      registerForm.paymentToken,
            "QpRecord[surcharge]":          registerForm.countPaidOnline.map { "\($0)" },
            "promo_code":                   promocode
        ]
        
        let formData: [MultipartFormDataObject] = certificates + MultipartFormDataObjects(params)

        NetworkService.shared.afPost(
            with: formData,
            to: "/ajax/save-record",
            responseType: GameOrderResponse.self
        ) { [weak self] serverResult in
            guard let self = self else { return }
            switch serverResult {
            case let .failure(error):
                self.output?.interactor(self, errorOccured: error)
            case let .success(response):
                self.output?.interactor(self, didRegisterWithResponse: response, paymentMethod: paymentMethod)
            }
        }
    }
    
    func checkSpecialCondition(_ value: String, forGameWithId id: Int, selectedTeamName name: String) {
        NetworkService.shared.get(
            SpecialCondition.Response.self,
            apiPath: "/ajax/check-code",
            parameters: [
                "game_id": "\(id)",
                "code": value,
                "name": name
            ]
        ) { [weak self] serverResult in
            guard let self = self else { return }
            switch serverResult {
            case let .failure(error):
                self.output?.interactor(self, errorOccured: error)
            case let .success(response):
                self.output?.interactor(self, didCheckSpecialCondition: value, with: response)
            }
        }
    }
}
