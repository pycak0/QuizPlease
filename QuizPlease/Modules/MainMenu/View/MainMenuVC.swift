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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
}

//MARK:- View Protocol
extension MainMenuVC: MainMenuViewProtocol {
    func configureTableView() {
        tableView.register(UINib(nibName: ScheduleCell.identifier, bundle: nil), forCellReuseIdentifier: ScheduleCell.identifier)
        tableView.register(UINib(nibName: ProfileCell.identifier, bundle: nil), forCellReuseIdentifier: ProfileCell.identifier)
        tableView.register(UINib(nibName: WarmupCell.identifier, bundle: nil), forCellReuseIdentifier: WarmupCell.identifier)
        tableView.register(UINib(nibName: HomeGameCell.identifier, bundle: nil), forCellReuseIdentifier: HomeGameCell.identifier)
        tableView.register(UINib(nibName: RatingCell.identifier, bundle: nil), forCellReuseIdentifier: RatingCell.identifier)
        //tableView.register(ScheduleCell.self, forCellReuseIdentifier: ScheduleCell.identifier)
        
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
        guard let items = presenter.menuItems else { return UITableViewCell() }
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: items[indexPath.row].identifier) as? MenuCellItem else {
            fatalError("Invalid Cell Kind")
        }
        let menuItem = items[indexPath.row]
        
        cell.configureCell(with: menuItem)
        
        return cell
    }
    
}

extension MainMenuVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return presenter.menuItems?[indexPath.row].height ?? 0
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.setNeedsLayout()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        presenter.didSelectMenuItem(at: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? MenuCellItem {
            cell.scaleIn()
        }
    }
    
    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? MenuCellItem {
            cell.scaleOut()
        }
    }
    
}
