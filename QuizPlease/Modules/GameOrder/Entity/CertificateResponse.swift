//
//  CertificateResponse.swift
//  QuizPlease
//
//  Created by Владислав on 12.12.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import Foundation

/// Тип сертификата
enum CertificateDiscountType {
    /// Сертификат на всю команду (без учета количества человек)
    case allTeamFree
    /// Сертификат на игру для определенного количества человек
    case numberOfPeopleForFree(_ number: Int)

    /// Создать тип сертификата по его коду
    init?(rawValue: Int) {
        switch rawValue {
        case 0:
            self = .allTeamFree
        case 1...9:
            self = .numberOfPeopleForFree(rawValue)
        case 11...15:
            self = .numberOfPeopleForFree(1)
        default:
            return nil
        }
    }
}
