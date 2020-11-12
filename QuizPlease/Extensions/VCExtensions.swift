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
    
    func configureRefreshControl(_ scrollView: UIScrollView, tintColor: UIColor = .lightGray, target: Any? = self, action: Selector) {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = tintColor
        refreshControl.addTarget(target, action: action, for: .valueChanged)
        scrollView.refreshControl = refreshControl
    }
    
    //MARK:- Clear Navigation Bar
    ///Clears navigation bar's background color, separator and back button
    func clearNavigationBar(clearBorder: Bool = true) {
        guard let navBar = navigationController?.navigationBar else { return }
        
        clearNavBarBackground(andBorder: clearBorder)
        navBar.isTranslucent = true
        navBar.isOpaque = false
        navBar.backIndicatorTransitionMaskImage = UIImage()
        navBar.backIndicatorImage = UIImage()
        navBar.layoutIfNeeded()
    }
    
    //MARK:- Clear Nav Bar Backgorund
    ///Clears navigation bar's background color and separator
    func clearNavBarBackground(andBorder: Bool = true) {
        guard let navBar = navigationController?.navigationBar else { return }
        
        navBar.backgroundColor = .clear
        navBar.setBackgroundImage(UIImage(), for: .default)
        if andBorder {
            navBar.shadowImage = UIImage()
        }
    }
    
    func setNavBarDefault(clearBorder: Bool = true) {
        guard let navBar = navigationController?.navigationBar else { return }
        navBar.setBackgroundImage(nil, for: .default)
        navBar.shadowImage = clearBorder ? UIImage() : nil
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
    
    //MARK:- Prepare Navigation Bar
    func prepareNavigationBar(title: String? = nil, titleAlignment: NSTextAlignment = .left, tintColor: UIColor? = nil, barTintColor: UIColor? = nil) {
        navigationController?.navigationBar.barTintColor = barTintColor ?? view.backgroundColor
        navigationController?.navigationBar.shadowImage = UIImage()
        
        if let color = tintColor {
            navigationController?.navigationBar.tintColor = color
        }
        navigationItem.titleView = TitleLabel(title: title ?? navigationItem.title ?? "",
                                              textColor: tintColor, textAlignment: titleAlignment)
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
