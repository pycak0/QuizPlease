//
//  SplashScreenVC.swift
//  QuizPlease
//
//  Created by Владислав on 07.12.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import UIKit

protocol SplashScreenViewProtocol: UIViewController {
    var presenter: SplashScreenPresenterProtocol! { get set }
}

class SplashScreenVC: UIViewController, SplashScreenViewProtocol {
    var presenter: SplashScreenPresenterProtocol!

    override func viewDidLoad() {
        super.viewDidLoad()
        SplashScreenBuilder().configure(self)
        presenter.viewDidLoad(self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        presenter.router.prepare(for: segue, sender: sender)
    }
}
