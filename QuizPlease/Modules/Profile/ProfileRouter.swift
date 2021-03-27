//
//  ProfileRouter.swift
//  QuizPlease
//
//  Created by Владислав on 04.08.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import UIKit

//MARK:- Router Protocol
protocol ProfileRouterProtocol: RouterProtocol {
    func showShop(with userInfo: UserInfo?)
    func showQRScanner()
    func showAddGameScreen(_ info: String)
    
    func showAuthScreen()
    func closeProfile()
}

class ProfileRouter: ProfileRouterProtocol {
    weak var viewController: UIViewController?
    
    required init(viewController: UIViewController) {
        self.viewController = viewController
    }
    
    //MARK:- Prepare for Segue
    func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "ShowQRScreenProfile":
            guard let vc = segue.destination as? QRScannerVC else { return }
            vc.delegate = viewController as? QRScannerVCDelegate
            
        case "AddGameProfile":
            guard let vc = segue.destination as? AddGameVC, let info = sender as? String else {
                fatalError("Incorrect Data Passed when showing AddGameVC from Profile")
            }
            vc.token = info
            vc.delegate = viewController as? AddGameVCDelegate
            
        case "ProfileAuthVC":
            guard let navC = segue.destination as? UINavigationController,
                  let vc = navC.viewControllers.first as? AuthVC
            else {
                fatalError("Incorrect Data Passed when showing AuthVC from Profile Router")
            }
            vc.delegate = self
            
        case "ShowShop":
            guard let vc = segue.destination as? ShopVC      
            else { fatalError("Incorrect Data Passed when showing ShopVC from Profile Router") }
            
            let userInfo = sender as? UserInfo
            ShopConfigurator().configure(vc, userInfo: userInfo)
            
        default:
            print("no preparations made for segue with id '\(String(describing: segue.identifier))' (from ProfileVC)")
        }
    }
    
    //MARK:- Segues
    func showShop(with userInfo: UserInfo?) {
        viewController?.performSegue(withIdentifier: "ShowShop", sender: userInfo)
    }
    
    func showQRScanner() {
        viewController?.performSegue(withIdentifier: "ShowQRScreenProfile", sender: nil)
    }
    
    func showAddGameScreen(_ info: String) {
        viewController?.performSegue(withIdentifier: "AddGameProfile", sender: info)
    }
    
    func showAuthScreen() {
        viewController?.performSegue(withIdentifier: "ProfileAuthVC", sender: nil)
    }
    
    func closeProfile() {
        viewController?.navigationController?.popViewController(animated: true)
    }
}

//MARK:- Auth VC Delegate
extension ProfileRouter: AuthVCDelegate {
    func didSuccessfullyAuthenticate(in authVC: AuthVC) {
        (viewController as? ProfileViewProtocol)?.presenter.didPerformAuth()
        authVC.dismiss(animated: true)
    }
    
    func didCancelAuth(in authVC: AuthVC) {
        authVC.dismiss(animated: true) { [unowned self] in
            viewController?.navigationController?.popViewController(animated: true)
        }
    }
}
