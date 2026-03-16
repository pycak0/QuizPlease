//
//  RegisterForm.swift
//  QuizPlease
//
//  Created by Владислав on 24.08.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

final class RegisterForm: Encodable {
    let cityId: Int
    let gameId: String

    var teamName: String = ""
    var captainName: String = ""
    var email: String = ""
    var phone: String = ""
    var count: Int = 2
    var countPaidOnline: Int?
    var isFirstTime: Bool = false
    var comment: String?
    var paymentType: PaymentType = .online
    var paymentToken: String?
    var isPersonalDataConsent: Bool = false
    var isMarketingConsent: Bool = false

    init(cityId: Int, gameId: String) {
        self.cityId = cityId
        self.gameId = gameId
    }
}

extension RegisterForm {
    /// Property validates email, checks that team and captain names are not empty
    /// but does not check if mobile phone is valid
    var isValid: Bool {
        return !gameId.isEmpty
            && email.isValidEmail
            && !teamName.isEmpty
            && !captainName.isEmpty
            && isPersonalDataConsent
    }
}
