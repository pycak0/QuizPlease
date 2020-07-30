//
//MARK:  MainMenuVC.swift
//  QuizPlease
//
//  Created by Владислав on 30.07.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import UIKit

class MainMenuVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    //MARK:- Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        configureTableView()
    }
    
    //MARK:- Prepare For Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "Show ScheduleVC":
            break
        case "Show WarmUpVC":
            break
        case "Show HomeGameVC":
            break
        case "Show ProfileVC":
            break
        case "Show RatingVC":
            break
        case "Show ShopVC":
            break
        default: break
        }
    }

}

extension MainMenuVC {

    func configureTableView() {
        tableView.register(UINib(nibName: ScheduleCell.nibName, bundle: nil), forCellReuseIdentifier: ScheduleCell.reuseIdentifier)
        
        tableView.delegate = self
        tableView.dataSource = self
    }
}

extension MainMenuVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ScheduleCell.reuseIdentifier) as! ScheduleCell
        var title = "Игры в барах"
        var supplementaryText = "Расписание"
        switch indexPath.row {
        case 1:
            title = "Личный кабинет"
            supplementaryText = "100 баллов"
        case 2:
            title = "Игры хоум"
            supplementaryText = "Играть"
        case 3:
            title = "Разминка"
            supplementaryText = "Перейти"
        case 4:
            title = "Магазин"
            supplementaryText = "К покупкам"
        default:
            break
        }
        
        cell.titleLabel.text = title
        cell.scheduleLabel.text = supplementaryText
        
        return cell
    }
    
}

extension MainMenuVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        var id = "Show ScheduleVC"
        switch indexPath.row {
        case 1:
            id = "Show ProfileVC"
        case 2:
            id = "Show HomeGameVC"
        case 3:
            id = "Show WarmUpVC"
        case 4:
            id = "Show ShopVC"
        default:
            break
        }
        performSegue(withIdentifier: id, sender: nil)
    }
}
