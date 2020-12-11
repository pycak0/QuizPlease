//
//  ScheduleRouter.swift
//  QuizPlease
//
//  Created by Владислав on 04.08.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import UIKit

//MARK:- Router Protocol
protocol ScheduleRouterProtocol: RouterProtocol {
    func showGameInfo(_ sender: GameInfoPresentAttributes)
    func showScheduleFilters(with filterInfo: ScheduleFilter)
    
    ///Pop current screen and push Warmup Screen onto the navigation stack
    func showWarmup(popCurrent: Bool)
    
    ///Pop current screen and push HomeGame Screen onto the navigation stack
    func showHomeGame(popCurrent: Bool)
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
    
    //MARK:- Prepare for Segue
    func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "ShowGameInfo":
            guard let gameInfo = sender as? GameInfoPresentAttributes,
                let vc = segue.destination as? GameOrderVC else { return }
            
            GameOrderConfigurator().configure(vc, withGameInfo: gameInfo)
        case "ShowFilters":
            guard let vc = segue.destination as? FiltersVC,
                let filter = sender as? ScheduleFilter else { return }
            vc.delegate = viewController as? FiltersVCDelegate
            vc.filter = filter
        default:
            print("Unknown segue")
        }
    }
    
    //MARK:- Segues
    func showGameInfo(_ sender: GameInfoPresentAttributes) {
        viewController?.performSegue(withIdentifier: "ShowGameInfo", sender: sender)
    }
    
    func showScheduleFilters(with filterInfo: ScheduleFilter) {
        viewController?.performSegue(withIdentifier: "ShowFilters", sender: filterInfo)
    }
    
    func showWarmup(popCurrent: Bool) {
        guard let vc = viewController?.storyboard?.instantiateViewController(withIdentifier: "WarmupVC") as? WarmupVC,
              let navC = viewController?.navigationController
        else { return }
        
        if popCurrent {
            navC.popViewController(animated: true)
        }
        navC.pushViewController(vc, animated: true)
        
    }
    
    func showHomeGame(popCurrent: Bool) {
        guard let vc = viewController?.storyboard?.instantiateViewController(withIdentifier: "HomeGamesListVC") as? HomeGamesListVC,
              let navC = viewController?.navigationController
        else { return }
        
        if popCurrent {
            navC.popViewController(animated: true)
        }
        navC.pushViewController(vc, animated: true)
        
    }
    
}
