//
//  TableCellProtocol.swift
//  QuizPlease
//
//  Created by Владислав on 12.08.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import UIKit

protocol TableCellProtocol: UITableViewCell {
    ///It is both a reuse identifier and a nib name
    static var identifier: String { get }
}
