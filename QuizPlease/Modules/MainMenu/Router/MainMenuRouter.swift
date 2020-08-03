//
//  MainMenuRouter.swift
//  QuizPlease
//
//  Created by Владислав on 03.08.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import UIKit

protocol RouterProtocol: class {
    init(viewController: UIViewController)
}

protocol MainMenuRouterProtocol: RouterProtocol {
    var viewController: MainMenuVC? { get set }
    func showMenuSection(_ kind: MenuItemKind, sender: Any?)
    func prepare(for segue: UIStoryboardSegue, sender: Any?)
}

class MainMenuRouter: MainMenuRouterProtocol {
    weak var viewController: MainMenuVC?
    
    required init(viewController: UIViewController) {
        self.viewController = viewController as? MainMenuVC
    }
    
    func showMenuSection(_ kind: MenuItemKind, sender: Any? = nil) {
        viewController?.performSegue(withIdentifier: kind.segueID, sender: sender)
    }
    
    func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("Prepraring for segue with id \(segue.identifier!)")
    }
    
}
