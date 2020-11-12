//
//  ShopRouter.swift
//  QuizPlease
//
//  Created by Владислав on 05.08.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import UIKit

protocol ShopRouterProtocol: RouterProtocol {
    func showConfirmScreen(for item: ShopItem)
    func showCompletionScreen(for item: ShopItem)
}

class ShopRouter: ShopRouterProtocol {
    weak var viewController: UIViewController?
    
    required init(viewController: UIViewController) {
        self.viewController = viewController
    }
    
    func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "ConfirmPurchase":
            guard let item = sender as? ShopItem, let vc = segue.destination as? ConfirmVC else { return }
            vc.shopItem = item
            vc.delegate = viewController as? ConfirmVCDelegate
        case "ShowShopCompletion":
            guard let item = sender as? ShopItem, let vc = segue.destination as? ShopCompletionVC else { return }
            vc.shopItem = item
            vc.delegate = viewController as? ShopCompletionVCDelegate
        default:
            print("Unknown segue id")
        }
    }
    
    func showConfirmScreen(for item: ShopItem) {
        viewController?.performSegue(withIdentifier: "ConfirmPurchase", sender: item)
    }
    
    func showCompletionScreen(for item: ShopItem) {
        viewController?.performSegue(withIdentifier: "ShowShopCompletion", sender: item)
    }
    
}
