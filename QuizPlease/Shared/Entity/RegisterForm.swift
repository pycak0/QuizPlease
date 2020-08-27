//
//  RegisterForm.swift
//  QuizPlease
//
//  Created by Владислав on 24.08.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import Foundation

struct RegisterForm: Encodable {
    var game_id: Int = -1
    var teamName: String = ""
    var captainName: String = ""
    var email: String = ""
    var phone: String = ""
    var count: Int = 2
    var countPaidOnline: Int?
    var certificates: [String]?
    var first_time: Bool = false
    var comment: String?
    var payment_type: PaymentType = .online
    
}
