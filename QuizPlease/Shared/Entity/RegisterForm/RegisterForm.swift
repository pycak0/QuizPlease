//
//  RegisterForm.swift
//  QuizPlease
//
//  Created by Владислав on 24.08.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import Foundation

struct RegisterForm: Encodable {
    var gameId: Int = -1
    var teamName: String = ""
    var captainName: String = ""
    var email: String = ""
    var phone: String = ""
    var count: Int = 2
    var countPaidOnline: Int?
    var certificates: String?
    var isFirstTime: Bool = false
    var comment: String?
    var paymentType: PaymentType = .online
    
}

extension RegisterForm {
    var isValid: Bool {
        return gameId >= 0 && email.isValidEmail && phone.count == 11 && teamName.count > 0 && captainName.count > 0
    }
}
