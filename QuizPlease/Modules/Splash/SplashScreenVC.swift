//
//  SplashScreenVC.swift
//  QuizPlease
//
//  Created by Владислав on 07.12.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import UIKit

class SplashScreenVC: UIViewController {
    
    private let timeout = 0.5

    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + timeout) {
            self.setRootVc()
        }
    }
    
    private func setRootVc() {
        let vc = storyboard?.instantiateViewController(withIdentifier: "MainMenuNavigationController")
        let window = UIApplication.shared.windows.first!
        window.rootViewController = vc
        window.makeKeyAndVisible()
        UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: nil, completion: nil)
    }

}
