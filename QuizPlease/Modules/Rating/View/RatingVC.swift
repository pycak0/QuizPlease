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
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var stackView: UIStackView!
    
    //MARK:- Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configurator.configure(self)
        presenter.configureViews()

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
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
        
        stackView.addGradient(colors: [.blue, .purple], insertAt: 0)
        configureSearchField()

    }
    
    func configureSearchField() {
        searchField.setImage(UIImage(named: "search"))
        searchField.attributedPlaceholder = NSAttributedString(
            string: "Поиск",
            attributes: [
                NSAttributedString.Key.font : UIFont(name: "Gilroy-Bold", size: 16)!,
                NSAttributedString.Key.foregroundColor : UIColor.white
        ])
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
        cell.configure(with: team.name, games: team.games, points: team.points)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
