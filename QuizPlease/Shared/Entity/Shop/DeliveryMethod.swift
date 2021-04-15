//
//  DeliveryMethod.swift
//  QuizPlease
//
//  Created by Владислав on 11.10.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import Foundation

enum DeliveryMethod {
    case game, online
    
    ///An identificator of DeliveryMethod used to perform server request
    var id: Int {
        switch self {
        case .online:
            return 2
        case .game:
            return 1
        }
    }
    
    ///A message to show to user after successful purchase request
    var message: String {
        switch self {
        case .online:
            return "Заказ был отправлен на указанную почту"
        case .game:
            return "Информация о заказе была отправлена на указанную почту"
        }
    }
}
