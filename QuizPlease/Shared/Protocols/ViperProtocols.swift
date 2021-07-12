//
//  ViperProtocols.swift
//  QuizPlease
//
//  Created by Владислав on 21.08.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import UIKit

protocol Router: AnyObject {
    ///Must be an '`unowned let`' constant
    var viewController: UIViewController { get }
    
    ///- parameter viewController: Must be an '`unowned let`' constant
    init(viewController: UIViewController)
}

protocol SegueRouter: Router {
    func prepare(for segue: UIStoryboardSegue, sender: Any?)
}

protocol Configurator {
    associatedtype ConfigurableView
    func configure(_ view: ConfigurableView)
}
