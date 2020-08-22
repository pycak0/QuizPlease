//
//MARK:  WarmupVC.swift
//  QuizPlease
//
//  Created by Владислав on 30.07.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import UIKit

protocol WarmupViewProtocol: UIViewController {
    var configurator: WarmupConfiguratorProtocol { get }
    var presenter: WarmupPresenterProtocol! { get set }
    
    //
}

class WarmupVC: UIViewController, WarmupViewProtocol {
    let configurator: WarmupConfiguratorProtocol = WarmupConfigurator()
    var presenter: WarmupPresenterProtocol!
    
    @IBOutlet weak var previewStack: UIStackView!

    override func viewDidLoad() {
        super.viewDidLoad()
        configurator.configure(self)
        presenter.configureViews()

    }
    
    @IBAction func startGamePressed(_ sender: UIButton) {
    }
    
}
