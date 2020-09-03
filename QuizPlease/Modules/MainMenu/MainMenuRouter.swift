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
    func showChooseCityScreen(_ selectedCity: City)
    func showQRScanner()
    func showAddGameScreen(_ info: String)
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
        switch segue.identifier {
        case "ShowQRScreenMenu":
            guard let vc = segue.destination as? QRScannerVC else { return }
            vc.delegate = viewController as? QRScannerVCDelegate
        case "AddGameMenu":
            guard let vc = segue.destination as? AddGameVC, let info = sender as? String else {
                fatalError("Incorrect Data passed when showing AddGameVC from MainMenuVC")
            }
            vc.gameName = info
        case "PickCityMenu":
            guard let navC = segue.destination as? UINavigationController,
                let vc = navC.viewControllers.first as? PickCityVC,
                let city = sender as? City else {
                fatalError("Incorrect Data passed when showing PickCityVC from MainMenuVC")
            }
            vc.selectedCity = city
            vc.delegate = viewController as? PickCityVCDelegate
        default:
            print("no preparations made for segue with id '\(String(describing: segue.identifier))'")
        }
    }
    
    func showChooseCityScreen(_ selectedCity: City) {
        viewController?.performSegue(withIdentifier: "PickCityMenu", sender: selectedCity)
    }
    
    func showQRScanner() {
        viewController?.performSegue(withIdentifier: "ShowQRScreenMenu", sender: nil)
    }
    
    func showAddGameScreen(_ info: String) {
        viewController?.performSegue(withIdentifier: "AddGameMenu", sender: info)
    }
    
}
