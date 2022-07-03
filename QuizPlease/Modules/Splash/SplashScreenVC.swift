//
//  SplashScreenVC.swift
//  QuizPlease
//
//  Created by Владислав on 07.12.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import UIKit

protocol SplashScreenViewProtocol: UIViewController, LoadingIndicator {
    var presenter: SplashScreenPresenterProtocol! { get set }
}

class SplashScreenVC: UIViewController, SplashScreenViewProtocol {
    var presenter: SplashScreenPresenterProtocol!

    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView! {
        didSet {
            activityIndicator.hidesWhenStopped = false
            activityIndicator.isHidden = false
            activityIndicator.alpha = 0
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        SplashScreenConfigurator().configure(self)
        presenter.viewDidLoad(self)
    }

    func startLoading() {
        activityIndicator.startAnimating()
        UIView.animate(withDuration: 0.5) {
            self.activityIndicator.alpha = 1
        }
    }

    func stopLoading() {
        UIView.animate(withDuration: 0.5) {
            self.activityIndicator.alpha = 0
        } completion: { _ in
            self.activityIndicator.stopAnimating()
        }
    }
}
