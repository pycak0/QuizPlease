//
//  ProfileRouter.swift
//  QuizPlease
//
//  Created by Владислав on 04.08.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import UIKit

protocol ProfileRouterProtocol: RouterProtocol {
    func showShop()
}

class ProfileRouter: ProfileRouterProtocol {
    var viewController: UIViewController?
    
    required init(viewController: UIViewController) {
        self.viewController = viewController
    }
    
    func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //
    }
    
    func showShop() {
        viewController?.performSegue(withIdentifier: "ShowShop", sender: nil)
    }
    
}
