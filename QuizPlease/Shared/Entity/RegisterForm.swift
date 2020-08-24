//
//  RegisterForm.swift
//  QuizPlease
//
//  Created by Владислав on 24.08.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import Foundation

struct RegisterForm: Codable {
    var teamName: String
    var captainName: String
    var email: String
    var phoneNumber: String
    var numberOfPeople: Int
    var certificate: String?
    var isFirstGame: Bool
    //var paymentType: PaymentType
    
}
