//
//  SplashScreenRouter.swift
//  QuizPlease
//
//  Created by Владислав on 12.04.2021.
//  Copyright © 2021 Владислав. All rights reserved.
//

import UIKit

protocol SplashScreenRouterProtocol: RouterProtocol {
    func showMainMenu()
}

class SplashScreenRouter: SplashScreenRouterProtocol {
    weak var viewController: UIViewController?
    
    required init(viewController: UIViewController) {
        self.viewController = viewController
    }
    
    func prepare(for segue: UIStoryboardSegue, sender: Any?) {}
    
    func showMainMenu() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "MainMenuNavigationController")
        let window = UIApplication.shared.windows.first!
        window.rootViewController = vc
        window.makeKeyAndVisible()
        UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: nil, completion: nil)
    }
}
