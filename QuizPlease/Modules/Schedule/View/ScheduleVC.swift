//
//MARK:  ScheduleVC.swift
//  QuizPlease
//
//  Created by Владислав on 30.07.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import UIKit

protocol ScheduleViewProtocol: UIViewController {
    var configarator: ScheduleConfiguratorProtocol { get }
    var presenter: SchedulePresenterProtocol! { get set }
    func reloadScheduleList()
}

class ScheduleVC: UIViewController {
    let configarator: ScheduleConfiguratorProtocol = ScheduleConfigurator()
    var presenter: SchedulePresenterProtocol!

    override func viewDidLoad() {
        super.viewDidLoad()
        configarator.configure(self)
        presenter.configureViews()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        presenter.router.prepare(for: segue, sender: sender)
    }

}

extension ScheduleVC: ScheduleViewProtocol {
    func reloadScheduleList() {
        
    }
    
}
