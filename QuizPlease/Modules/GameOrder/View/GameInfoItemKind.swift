//
//  GameInfoItemKind.swift
//  QuizPlease
//
//  Created by Владислав on 13.08.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import UIKit

extension GameOrderVC {
    enum GameInfoItemKind: Int, CaseIterable {
        case annotation, info, description, registration, certificate, firstPlay, payment
        
        var identifier: String {
            switch self {
            case .annotation:
                return GameAnnotationCell.identifier
            case .info:
                return GameInfoCell.identifier
            case .description:
                return GameGeneralDescriptionCell.identifier
            case .registration:
                return GameRegisterCell.identifier
            case .certificate:
                return GameCertificateCell.identifier
            case .firstPlay:
                return GameFirstPlayCell.identifier
            case .payment:
                return GamePayCell.identifier
            }
        }
        
        var height: CGFloat {
            switch self {
            case .annotation:
                return 272
            case .info:
                return 340
            case .description:
                return 233
            case .registration:
                return 640
            case .certificate:
                return 210
            case .firstPlay:
                return 90
            case .payment:
                return 444
            }
        }
    }
}
