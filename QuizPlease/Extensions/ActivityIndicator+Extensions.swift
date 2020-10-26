//
//  ActivityIndicator+Extensions.swift
//  mvd
//
//  Created by Владислав on 21.10.2020.
//  Copyright © 2020 AMG-BS. All rights reserved.
//

import UIKit

public extension UIActivityIndicatorView {
    //MARK:- Bar Button Loading Indicator
    func enableInNavBar(of navigationItem: UINavigationItem){
        self.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        let barButton = UIBarButtonItem(customView: self)
        navigationItem.setRightBarButton(barButton, animated: true)
        self.isHidden = false
        self.startAnimating()
    }
    
    func disableInNavBar(of navigationItem: UINavigationItem, replaceWithButton: UIBarButtonItem?){
        self.stopAnimating()
        self.isHidden = true
        navigationItem.setRightBarButton(replaceWithButton, animated: true)
    }
    
    ///- parameter bgColor: if not `nil`, sets a background color for a spinner. Otherwise, does nothing
    ///- parameter color : `color ` property of spinner. If `nil`, does nothing
    func enableCentered(in view: UIView,
                        color: UIColor? = nil, bgColor: UIColor? = nil,
                        isCircle: Bool = false, width: CGFloat = 50) {
        
        self.frame = CGRect(x: (view.bounds.midX - width/2), y: (view.bounds.midY - width/2), width: width, height: width)
        self.clipsToBounds = true
        self.layer.cornerRadius = isCircle ? (width / 2) : 10

        self.blurView.setup(style: .regular, alpha: 1).enable()
        if let color = bgColor {
            self.blurView.backgroundColor = color
        }
        if let color = color {
            self.color = color
        }
        
        view.addSubview(self)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.heightAnchor.constraint(equalToConstant: width),
            self.widthAnchor.constraint(equalToConstant: width),
            self.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            self.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        self.startAnimating()
    }
}
