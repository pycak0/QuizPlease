//
//  WarmupRouter.swift
//  QuizPlease
//
//  Created by Владислав on 04.08.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import UIKit

protocol WarmupRouterProtocol: Router {}

class WarmupRouter: WarmupRouterProtocol {
    unowned let viewController: UIViewController
    
    required init(viewController: UIViewController) {
        self.viewController = viewController
    }
}
