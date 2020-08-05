//
//  VCExtensions.swift
//  QuizPlease
//
//  Created by Владислав on 05.08.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import UIKit

// Extensions for the UIViewController

extension UIViewController {
    
    //MARK:- Clear Navigation Bar
    ///Clears navigation bar's background color and separator
    func clearNavigationBar(clearBorder: Bool = true) {
        guard let navBar = navigationController?.navigationBar else {
            return
        }
        navBar.backgroundColor = .clear
        navBar.setBackgroundImage(UIImage(), for: .default)
        if clearBorder {
            navBar.shadowImage = UIImage()
        }
        navBar.isTranslucent = true
        navBar.isOpaque = false
        navBar.backIndicatorTransitionMaskImage = UIImage()
        navBar.backIndicatorImage = UIImage()
        navBar.layoutIfNeeded()
    }
    
    func setupNavBarView(_ customNavBar: NavigationBar) {
        clearNavigationBar()
    
        view.addSubview(customNavBar)
        
        customNavBar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            customNavBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            customNavBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            customNavBar.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            customNavBar.heightAnchor.constraint(equalToConstant: navBarHeight)
        ])
        
    }
    
    var navBarHeight: CGFloat {
        return 120
//        return 120
//        switch UIScreen.main.nativeBounds.height {
//        case 2436, 2688, 1792:
//            return 100
//        // iPhone 5s-style
//        case 1136:
//            return 80
//        // Any other iPhone
//        default:
//            return 90
//        }
    }
}
