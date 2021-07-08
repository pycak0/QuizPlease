//
//  GameOrderCellProtocol.swift
//  QuizPlease
//
//  Created by Владислав on 24.08.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import UIKit

protocol GameOrderCellProtocol: UITableViewCell, IdentifiableType {
    var delegate: AnyObject? { get set }
}
