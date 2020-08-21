//
//  MainMenuRouter.swift
//  QuizPlease
//
//  Created by Владислав on 03.08.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import UIKit

protocol MainMenuRouterProtocol: RouterProtocol {
    //var viewController: MainMenuVC? { get set }
    func showMenuSection(_ kind: MenuItemProtocol, sender: Any?)
    func showChooseCityScreen()
    func showQRScanner()
}

class MainMenuRouter: MainMenuRouterProtocol {
    weak var viewController: UIViewController?
    
    required init(viewController: UIViewController) {
        self.viewController = viewController
    }
    
    func showMenuSection(_ kind: MenuItemProtocol, sender: Any? = nil) {
        viewController?.performSegue(withIdentifier: kind._kind.segueID, sender: sender)
    }
    
    func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("Prepraring for segue with id '\(segue.identifier!)'")
    }
    
    func showChooseCityScreen() {
        print("Choosing city is not implemented")
    }
    
    func showQRScanner() {
        viewController?.performSegue(withIdentifier: "ShowQRScreenMenu", sender: nil)
    }
    
}

extension MainMenuRouter: NavigationBarDelegate {
    func backButtonPressed(_ sender: Any) {
        viewController?.navigationController?.popViewController(animated: true)
    }
        
}
