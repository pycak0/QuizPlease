//
//  ScheduleRouter.swift
//  QuizPlease
//
//  Created by Владислав on 04.08.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import UIKit

protocol ScheduleRouterProtocol: RouterProtocol {
    func showGameInfo(_ sender: GameInfoPresentAttributes)
}

struct GameInfoPresentAttributes {
    var game: GameInfo
    var shouldScrollToSignUp: Bool
}

class ScheduleRouter: ScheduleRouterProtocol {

    weak var viewController: UIViewController?
    
    required init(viewController: UIViewController) {
        self.viewController = viewController
    }
    
    func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "ShowGameInfo":
            guard let gameInfo = sender as? GameInfoPresentAttributes,
                let vc = segue.destination as? GameOrderVC else { return }
            
            vc.configurator.configure(vc, withGameInfo: gameInfo)
        default:
            print("Unknown segue")
        }
    }
    
    func showGameInfo(_ sender: GameInfoPresentAttributes) {
        viewController?.performSegue(withIdentifier: "ShowGameInfo", sender: sender)
    }
    
}