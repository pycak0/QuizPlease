//
//  GameOrderRouter.swift
//  QuizPlease
//
//  Created by Владислав on 13.08.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import UIKit

//MARK:- Router Protocol
protocol GameOrderRouterProtocol: RouterProtocol {
    //func showPayScreen()
    
    func showCompletionScreen(with gameInfo: GameInfo, numberOfPeopleInTeam number: Int)
}

class GameOrderRouter: GameOrderRouterProtocol {
    weak var viewController: UIViewController?
    
    required init(viewController: UIViewController) {
        self.viewController = viewController
    }
    
    //MARK:- Prepare for segue
    func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "ShowGameOrderCompletionScreen":
            guard let navC = segue.destination as? UINavigationController,
                  let vc = navC.viewControllers.first as? GameOrderCompletionVC,
                  let dict = sender as? [String: Any],
                  let gameInfo = dict["info"] as? GameInfo,
                  let number = dict["number"] as? Int else {
                fatalError("Incorrect data passed on segue to GameOrderCompletionVC")
            }
            vc.gameInfo = gameInfo
            vc.numberOfPeopleInTeam = number
            vc.delegate = self
        default:
            print("No preparations made for segue with id '\(segue.identifier ?? "")' from GameOrderVC")
        }
    }
    
    //MARK:- Show Completion Screen
    func showCompletionScreen(with gameInfo: GameInfo, numberOfPeopleInTeam number: Int) {
        let dict: [String: Any] = [
            "info": gameInfo,
            "number": number
        ]
        viewController?.performSegue(withIdentifier: "ShowGameOrderCompletionScreen", sender: dict)
    }
    
}

//MARK:- GameOrderCompletionDelegate
extension GameOrderRouter: GameOrderCompletionDelegate {
    func didPressDismissButton(in vc: GameOrderCompletionVC) {
        vc.dismiss(animated: true)
        viewController?.navigationController?.popViewController(animated: true)
    }
}
