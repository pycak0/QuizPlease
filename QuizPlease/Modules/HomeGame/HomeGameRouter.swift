//
//  HomeGameRouter.swift
//  QuizPlease
//
//  Created by Владислав on 04.08.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import UIKit

protocol HomeGameRouterProtocol: RouterProtocol {
    func showGame(_ game: HomeGame)
}

class HomeGameRouter: HomeGameRouterProtocol {
    var viewController: UIViewController?
    
    required init(viewController: UIViewController) {
        self.viewController = viewController
    }
    
    func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "ShowHomeGame":
            guard let game = sender as? HomeGame, let vc = segue.destination as? HomeGameVideoVC else {
                print("Incorrect data")
                return
            }
            vc.homeGame = game
        default:
            print("unknown segue from Home Games List")
        }
    }
    
    func showGame(_ game: HomeGame) {
        viewController?.performSegue(withIdentifier: "ShowHomeGame", sender: game)
    }
    
}
