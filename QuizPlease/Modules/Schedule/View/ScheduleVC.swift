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
    func reloadGame(at index: Int)
    func endLoadingAnimation()
    func showNoGamesScheduled()
    
    func configureTableView()
}

class ScheduleVC: UIViewController {
    let configarator: ScheduleConfiguratorProtocol = ScheduleConfigurator()
    var presenter: SchedulePresenterProtocol!
    
    @IBOutlet weak var tableView: UITableView!

    //MARK:- Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configarator.configure(self)
        presenter.configureViews()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        presenter.router.prepare(for: segue, sender: sender)
    }
    
    @IBAction func filtersButtonPressed(_ sender: Any) {
        presenter.didPressFilterButton()
    }
    
    @objc private func refreshControlTriggered() {
        presenter.handleRefreshControl()
    }
    
}

//MARK:- View Protocol
extension ScheduleVC: ScheduleViewProtocol {
    func reloadScheduleList() {
        tableView.isHidden = false
        tableView.reloadData()
    }
    
    func reloadGame(at index: Int) {
        tableView.isHidden = false
        tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .fade)
    }
    
    func endLoadingAnimation() {
        tableView.refreshControl?.endRefreshing()
    }
    
    func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        configureRefreshControl(tableView, tintColor: .systemBlue, action: #selector(refreshControlTriggered))
        
    }
    
    func showNoGamesScheduled() {
        tableView.isHidden = true
    }
    
}

extension ScheduleVC: FiltersVCDelegate {
    func didChangeFilter(_ newFilter: ScheduleFilter) {
        presenter.didChangeScheduleFilter(newFilter: newFilter)
    }
    
    func didEndEditingFilters() {
        //
    }
}


//MARK:- Data Source & Delegate
extension ScheduleVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.games?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ScheduleGameCell.identifier, for: indexPath) as! ScheduleGameCell
        
        guard let game = presenter.games?[indexPath.row] else { return cell }
        cell.delegate = self
        cell.configureCell(model: game)
        
        return cell
    }
    
}

//MARK:- ScheduleGameCellDelegate
extension ScheduleVC: ScheduleGameCellDelegate {
    func signUpButtonPressed(in cell: ScheduleGameCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        presenter.didSignUp(forGameAt: indexPath.row)
    }
    
    func infoButtonPressed(in cell: ScheduleGameCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        presenter.didPressInfoButton(forGameAt: indexPath.row)
    }
    
    func locationButtonPressed(in cell: ScheduleGameCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        presenter.didAskLocation(forGameAt: indexPath.row)
    }
    
    func remindButtonPressed(in cell: ScheduleGameCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        presenter.didAskNotification(forGameAt: indexPath.row)
    }
    
}
