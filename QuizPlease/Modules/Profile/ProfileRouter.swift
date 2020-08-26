//
//  ProfileRouter.swift
//  QuizPlease
//
//  Created by Владислав on 04.08.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import UIKit

protocol ProfileRouterProtocol: RouterProtocol {
    func showShop()
    func showQRScanner()
    func showAddGameScreen(_ info: String)
}

class ProfileRouter: ProfileRouterProtocol {
    weak var viewController: UIViewController?
    
    required init(viewController: UIViewController) {
        self.viewController = viewController
    }
    
    func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "ShowQRScreenProfile":
            guard let vc = segue.destination as? QRScannerVC else { return }
            vc.delegate = viewController as? QRScannerVCDelegate
        case "AddGameProfile":
            guard let vc = segue.destination as? AddGameVC, let info = sender as? String else {
                fatalError("Incorrect Data Passed when showing AddGameVC from Profile")
            }
            vc.gameName = info
        default:
            print("no preparations made for segue with id '\(String(describing: segue.identifier))' (from ProfileVC)")
        }
    }
    
    func showShop() {
        viewController?.performSegue(withIdentifier: "ShowShop", sender: nil)
    }
    
    func showQRScanner() {
        viewController?.performSegue(withIdentifier: "ShowQRScreenProfile", sender: nil)
    }
    
    func showAddGameScreen(_ info: String) {
        viewController?.performSegue(withIdentifier: "AddGameProfile", sender: info)
    }
    
}
