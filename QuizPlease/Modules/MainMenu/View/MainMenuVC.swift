//
//MARK:  MainMenuVC.swift
//  QuizPlease
//
//  Created by Владислав on 30.07.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import UIKit

protocol MainMenuViewProtocol: UIViewController {
    var presenter: MainMenuPresenterProtocol! { get set }    
    func configureTableView()
    func reloadMenuItems()
    func failureLoadingMenuItems(_ error: Error)
    
}

class MainMenuVC: UIViewController {
    let configurator: MainMenuConfiguratorProtocol = MainMenuConfigurator()
    var presenter: MainMenuPresenterProtocol!

    @IBOutlet weak var tableView: UITableView!
        
    //MARK:- Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configurator.configure(self)
        presenter.configureViews()
    }
    
}

//MARK:- View Protocol
extension MainMenuVC: MainMenuViewProtocol {
    func configureTableView() {
        tableView.register(UINib(nibName: ScheduleCell.nibName, bundle: nil), forCellReuseIdentifier: ScheduleCell.reuseIdentifier)
        //tableView.register(ScheduleCell.self, forCellReuseIdentifier: ScheduleCell.reuseIdentifier)
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func failureLoadingMenuItems(_ error: Error) {
        showErrorConnectingToServerAlert()
    }
    
    func reloadMenuItems() {
        tableView.reloadData()
    }
    
}

//MARK:- Table View Data Source
extension MainMenuVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.menuItems?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ScheduleCell.reuseIdentifier) as? ScheduleCell else {
            fatalError("Invalid Cell Kind")
        }
        let menuItem = presenter.menuItems?[indexPath.row]
        
        cell.titleLabel.text = menuItem?.title
        cell.accessoryLabel.text = menuItem?.supplementaryText
        
        return cell
    }
    
}

extension MainMenuVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return presenter.menuItems?[indexPath.row].height ?? 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        presenter.didSelectMenuItem(at: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? MenuCellItem {
            cell.cellView.scaleIn()
        }
    }
    
    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? MenuCellItem {
            cell.cellView.scaleOut()
        }
    }
    
}
