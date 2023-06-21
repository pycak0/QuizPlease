//
//  SplashScreenVC.swift
//  QuizPlease
//
//  Created by Владислав on 07.12.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import UIKit

protocol SplashScreenViewProtocol: UIViewController, LoadingIndicator {

    var presenter: SplashScreenViewOutput! { get set }
}

protocol SplashScreenViewOutput {

    func viewDidLoad(_ view: SplashScreenViewProtocol)
}

final class SplashScreenVC: UIViewController, SplashScreenViewProtocol {

    var presenter: SplashScreenViewOutput!

    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }

    // MARK: - UI Elements

    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView! {
        didSet {
            activityIndicator.hidesWhenStopped = false
            activityIndicator.isHidden = false
            activityIndicator.alpha = 0
        }
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        SplashScreenConfigurator().configure(self)
        presenter.viewDidLoad(self)
    }

    // MARK: - LoadingIndicator Protocol

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
