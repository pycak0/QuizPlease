//
//MARK:  RatingVC.swift
//  QuizPlease
//
//  Created by Владислав on 30.07.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import UIKit

//MARK:- View Protocol
protocol RatingViewProtocol: UIViewController {
    var configurator: RatingConfiguratorProtocol! { get }
    var presenter: RatingPresenterProtocol! { get set }
    
    func reloadRatingList()
    func configureTableView()
}

class RatingVC: UIViewController {
    let configurator: RatingConfiguratorProtocol! = RatingConfigurator()
    var presenter: RatingPresenterProtocol!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var expandingHeader: ExpandingHeader!
    
    //MARK:- Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configurator.configure(self)
        presenter.configureViews()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.tintColor = .white
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        navigationController?.navigationBar.tintColor = .labelAdapted
    }
    
    @objc
    private func refreshControlTriggered() {
        presenter.handleRefreshControl() { [weak self] in
            guard let self = self else { return }
            self.tableView.refreshControl?.endRefreshing()
        }
    }

}

//MARK:- Protocol Implementation
extension RatingVC: RatingViewProtocol {
    func reloadRatingList() {
        tableView.reloadSections(IndexSet(arrayLiteral: 0), with: .fade)
    }
    
    func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = .lemon
        refreshControl.addTarget(self, action: #selector(refreshControlTriggered), for: .valueChanged)
        tableView.refreshControl = refreshControl
        
        expandingHeader.configure(self, selectedScope: presenter.filter.scope.rawValue, selectedGameType: presenter.availableGameTypeNames.first!)
    }
    
}

//MARK:- ExpandingHeaderDelegate
extension RatingVC: ExpandingHeaderDelegate {
    func didPressGameTypeView(in expandingHeader: ExpandingHeader) {
        showChooseItemActionSheet(itemNames: presenter.availableGameTypeNames) { [unowned self] (selectedName, index) in
            expandingHeader.selectedGameTypeLabel.text = selectedName
            self.presenter.didChangeLeague(index)
        }
    }
    
    func expandingHeader(_ expandingHeader: ExpandingHeader, didChangeStateTo isExpanded: Bool) {
        tableView.reloadSections(IndexSet(arrayLiteral: 0), with: .automatic)
    }
    
    func expandingHeader(_ expandingHeader: ExpandingHeader, didChange selectedSegment: Int) {
        presenter.didChangeRatingScope(selectedSegment)
    }
    
    func expandingHeader(_ expandingHeader: ExpandingHeader, didEndSearchingWith query: String) {
        presenter.didChangeTeamName(query)
    }
    
    func expandingHeader(_ expandingHeader: ExpandingHeader, didChange query: String) {
        print("query: \(query)")
    }
}


//MARK:- Data Source & Delegate
extension RatingVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.teams.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RatingCell.identifier, for: indexPath) as? RatingCell else { fatalError("Invalid Cell Kind") }
        
        let team = presenter.teams[indexPath.row]
        cell.configure(with: team.name, games: team.games, points: team.pointsTotal)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
