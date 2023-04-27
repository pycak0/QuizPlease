//
//  QPAlertButtonModel.swift
//  QuizPlease
//
//  Created by Владислав on 27.04.2023.
//  Copyright © 2023 Владислав. All rights reserved.
//

import UIKit

struct QPAlertButtonModel {

    let title: String
    let style: Style
    let tapAction: (() -> Void)?
}

extension QPAlertButtonModel {

    enum Style {
        case primary, basic

        var titleColor: UIColor {
            switch self {
            case .primary:
                return .black
            case .basic:
                return .white
            }
        }

        var backgroundColor: UIColor {
            switch self {
            case .primary:
                return .white
            case .basic:
                return .white.withAlphaComponent(0.1)
            }
        }
    }
}
