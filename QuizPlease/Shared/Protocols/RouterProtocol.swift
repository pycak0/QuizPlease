//
//  RouterProtocol.swift
//  QuizPlease
//
//  Created by Владислав on 21.08.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import UIKit

protocol RouterProtocol: class {
    ///Must be weak
    var viewController: UIViewController? { get set }
    init(viewController: UIViewController)
    func prepare(for segue: UIStoryboardSegue, sender: Any?)
}
