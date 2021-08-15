//
//  MainMenuRouter.swift
//  QuizPlease
//
//  Created by Владислав on 03.08.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import UIKit

protocol MainMenuRouterProtocol: SegueRouter {
    func showMenuSection(_ kind: MainMenuItemProtocol, sender: Any?)
    func showChooseCityScreen(selectedCity: City)
    func showQRScanner()
    func showAddGameScreen(_ info: String)
}

class MainMenuRouter: MainMenuRouterProtocol {
    unowned let viewController: UIViewController
    private unowned let storyboard: UIStoryboard
    private var navigationController: UINavigationController {
        viewController.navigationController!
    }
    
    required init(viewController: UIViewController) {
        self.viewController = viewController
        self.storyboard = viewController.storyboard ?? UIStoryboard(name: "Main", bundle: .main)
    }
    
    //MARK:- Prepare for Segue
    func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "ShowQRScreenMenu":
            guard let vc = segue.destination as? QRScannerVC else { return }
            vc.delegate = viewController as? QRScannerVCDelegate

        case "AddGameMenu":
            guard let vc = segue.destination as? AddGameVC,
                  let info = sender as? String
            else { fatalError("Incorrect Data passed when showing AddGameVC from MainMenuVC") }
            
            vc.token = info

        case "Show ProfileVC":
            guard let vc = segue.destination as? ProfileVC
            else { fatalError("Incorrect Data passed when showing ProfileVC from MainMenu Router") }
            
            let userInfo = sender as? UserInfo
            ProfileConfigurator().configure(vc, userInfo: userInfo)

        case "Show ShopVC":
            guard let vc = segue.destination as? ShopVC
            else { fatalError("Incorrect Data passed when showing ShopVC from MainMenu Router") }
            
            let userInfo = sender as? UserInfo
            ShopConfigurator().configure(vc, userInfo: userInfo)

        default:
            print("no preparations were made for segue with id '\(String(describing: segue.identifier))'")
        }
    }
    
    //MARK:- Segues
    func showMenuSection(_ kind: MainMenuItemProtocol, sender: Any?) {
        viewController.performSegue(withIdentifier: kind._kind.segueID, sender: sender)
    }
    
    func showChooseCityScreen(selectedCity: City) {
        let pickCityVc = PickCityVC(
            selectedCity: selectedCity,
            delegate: viewController as? PickCityVCDelegate
        )
        let navC = UINavigationController(rootViewController: pickCityVc)
        viewController.present(navC, animated: true)
    }
    
    func showQRScanner() {
        viewController.performSegue(withIdentifier: "ShowQRScreenMenu", sender: nil)
    }
    
    func showAddGameScreen(_ info: String) {
        viewController.performSegue(withIdentifier: "AddGameMenu", sender: info)
    }
    
    private func couldNotInstantiateError<T>(type: T.Type) {
        fatalError("Could not instantiate \(type) on storyboard \(storyboard) with identifier '\(type)'")
    }
}
