//
//  DeliveryMethod.swift
//  QuizPlease
//
//  Created by Владислав on 11.10.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import Foundation

enum DeliveryMethod {
    case game(_ gameId: String)
    case email(_ emailAddress: String)
    
    ///An identificator of DeliveryMethod used to perform server request
    var id: Int {
        switch self {
        case .email:
            return 1
        case .game:
            return 2
        }
    }
    
    ///A message to show to user after successful purchase request
    var message: String {
        switch self {
        case .email:
            return "Заказ был отправлен на указанную почту"
        case .game:
            return "Вы сможете забрать Ваш заказ на указанной игре"
        }
    }
}
