//
//  RatingRouter.swift
//  QuizPlease
//
//  Created by Владислав on 04.08.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import UIKit

protocol RatingRouterProtocol: RouterProtocol {
    //
}

class RatingRouter: RatingRouterProtocol {
    weak var viewController: UIViewController?
    
    required init(viewController: UIViewController) {
        self.viewController = viewController
    }
    
    func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //
    }
    
}
