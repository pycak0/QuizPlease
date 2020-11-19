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
    func appendRaingItems(at indices: Range<Int>)
    func endLoadingAnimation()
    func startLoadingAnimation()
    
    func configureTableView()
}

class RatingVC: UIViewController {
    let configurator: RatingConfiguratorProtocol! = RatingConfigurator()
    var presenter: RatingPresenterProtocol!
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var expandingHeader: ExpandingHeader!
    
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
        presenter.handleRefreshControl()
    }

}

//MARK:- Protocol Implementation
extension RatingVC: RatingViewProtocol {
    func reloadRatingList() {
        tableView.reloadSections(IndexSet(arrayLiteral: 0), with: .fade)
    }
    
    func appendRaingItems(at indices: Range<Int>) {
        let indexPaths = indices.map { IndexPath(row: $0, section: 0) }
        tableView.beginUpdates()
        tableView.insertRows(at: indexPaths, with: .automatic)
        tableView.endUpdates()
    }
    
    func endLoadingAnimation() {
        if tableView.refreshControl?.isRefreshing ?? false {
            tableView.refreshControl?.endRefreshing()
        }
        tableView.tableFooterView?.isHidden = true
    }
    
    func startLoadingAnimation() {
        tableView.tableFooterView?.isHidden = false
    }
    
    func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsSelection = false
        
        configureRefreshControl(tableView, tintColor: .lemon, action: #selector(refreshControlTriggered))
        
        expandingHeader.configure(self, selectedScope: presenter.filter.scope.rawValue, selectedGameType: presenter.availableGameTypeNames.first!)
    }
    
}

//MARK:- ExpandingHeaderDelegate
extension RatingVC: ExpandingHeaderDelegate {
    func didPressGameTypeView(in expandingHeader: ExpandingHeader, completion: @escaping (String?) -> Void) {
        showChooseItemActionSheet(itemNames: presenter.availableGameTypeNames) { [unowned self] (selectedName, index) in
            self.presenter.didChangeLeague(index)
            
            completion(selectedName)
        }
    }
    
    func expandingHeader(_ expandingHeader: ExpandingHeader, didChangeStateTo isExpanded: Bool) {
        tableView.reloadSections(IndexSet(arrayLiteral: 0), with: .automatic)
    }
    
    func expandingHeader(_ expandingHeader: ExpandingHeader, didChange selectedSegment: Int) {
        presenter.didChangeRatingScope(selectedSegment)
    }
    
    func expandingHeader(_ expandingHeader: ExpandingHeader, didEndSearchingWith query: String) {
        presenter.searchByTeamName(query)
    }
    
    func expandingHeader(_ expandingHeader: ExpandingHeader, didChange query: String) {
        presenter.didChangeTeamName(query)
    }
    
    func expandingHeader(_ expandingHeader: ExpandingHeader, didPressReturnButtonWith query: String) {
        presenter.searchByTeamName(query)
    }
}


//MARK:- Data Source & Delegate
extension RatingVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.filteredTeams.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RatingCell.identifier, for: indexPath) as? RatingCell else { fatalError("Invalid Cell Kind") }
        
        let team = presenter.filteredTeams[indexPath.row]
        cell.configure(with: team.name, games: team.games, points: Int(team.pointsTotal), imagePath: team.imagePath)
        
        let teamsCount = presenter.filteredTeams.count
        if indexPath.row == teamsCount - 5 {
            presenter.didAlmostScrollToEnd()
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
