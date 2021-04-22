//
//  PaymentOption.swift
//  QuizPlease
//
//  Created by Владислав on 05.04.2021.
//  Copyright © 2021 Владислав. All rights reserved.
//

import Foundation

///Доступные варианты оплаты игры
enum PaymentOption: Int, Decodable {
    ///Оплата только наличными
    case cashOnly = 0
    
    ///Оплата банковской картой в месте игры
    case creditCardOffline = 1
    
    ///Оплата наличными или картой в месте игры
    case cashOrCreditOffline = 2
    
    ///Оплата онлайн через провайдера платежей (в приложении)
    case onlineInApp = 3
    
    ///Оплата онлайн НЕ через провайдера (смс, переводы и др.)
    case onlineCustom = 4
    
    ///Оплата наличными или онлайн через провайдера платежей (в приложении)
    case cashOrOnlineInApp = 5
}
