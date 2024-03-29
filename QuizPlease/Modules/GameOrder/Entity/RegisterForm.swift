//
//  RegisterForm.swift
//  QuizPlease
//
//  Created by Владислав on 24.08.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

final class RegisterForm: Encodable {
    let cityId: Int
    let gameId: Int

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

    init(cityId: Int, gameId: Int) {
        self.cityId = cityId
        self.gameId = gameId
    }
}

extension RegisterForm {
    /// Property validates email, checks that team and captain names are not empty
    /// but does not check if mobile phone is valid
    var isValid: Bool {
        return gameId >= 0
            && email.isValidEmail
            && !teamName.isEmpty
            && !captainName.isEmpty
    }
}
