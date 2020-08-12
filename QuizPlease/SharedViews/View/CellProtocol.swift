//
//  CellProtocol.swift
//  QuizPlease
//
//  Created by Владислав on 12.08.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import Foundation

protocol CellProtocol {
    ///It is both a reuse identifier and a nib name
    static var identifier: String { get }
}
