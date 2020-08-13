//
//  ScheduleRouter.swift
//  QuizPlease
//
//  Created by Владислав on 04.08.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import UIKit

protocol ScheduleRouterProtocol: RouterProtocol {
    func showGameInfo(_ sender: GameInfo)
}

class ScheduleRouter: ScheduleRouterProtocol {
    var viewController: UIViewController?
    
    required init(viewController: UIViewController) {
        self.viewController = viewController
    }
    
    func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "ShowGameInfo":
            guard let game = sender as? GameInfo,
                let vc = segue.destination as? GameOrderVC else { return }
            
            vc.configurator.configure(vc, withGame: game)
        default:
            print("Unknown segue")
        }
    }
    
    func showGameInfo(_ sender: GameInfo) {
        viewController?.performSegue(withIdentifier: "ShowGameInfo", sender: sender)
    }
    
}
