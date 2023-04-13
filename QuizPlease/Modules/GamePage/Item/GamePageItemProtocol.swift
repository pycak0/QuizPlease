//
//  GamePageItemProtocol.swift
//  QuizPlease
//
//  Created by Владислав on 10.04.2023.
//  Copyright © 2023 Владислав. All rights reserved.
//

import Foundation

/// Item protocol for game page view
protocol GamePageItemProtocol {

    func cellClass(with context: GamePageViewContext) -> AnyClass
}
