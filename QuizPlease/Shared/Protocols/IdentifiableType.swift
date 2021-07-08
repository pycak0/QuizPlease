//
//  IdentifiableType.swift
//  QuizPlease
//
//  Created by Владислав on 12.08.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import UIKit

///Protocol for type's static `identifier` that is name of type by default
protocol IdentifiableType {
    static var identifier: String { get }
}

extension IdentifiableType {
    static var identifier: String { "\(Self.self)" }
}
