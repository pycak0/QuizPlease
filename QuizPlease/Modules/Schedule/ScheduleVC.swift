//
//MARK:  ScheduleVC.swift
//  QuizPlease
//
//  Created by Владислав on 30.07.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import UIKit

class ScheduleVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.titleView = TitleLabel(title: "Расписание игр")
        
        navigationController?.navigationBar.barTintColor = view.backgroundColor
        navigationController?.navigationBar.shadowImage = UIImage()
    }

}
