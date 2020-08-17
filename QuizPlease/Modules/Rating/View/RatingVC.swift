//
//MARK:  RatingVC.swift
//  QuizPlease
//
//  Created by Владислав on 30.07.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import UIKit

protocol RatingViewProtocol: UIViewController {
    var configurator: RatingConfiguratorProtocol! { get }
    var presenter: RatingPresenterProtocol! { get set }
    
    func reloadRating()
    func configureTableView()
}

class RatingVC: UIViewController {
    let configurator: RatingConfiguratorProtocol! = RatingConfigurator()
    var presenter: RatingPresenterProtocol!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

}

extension RatingVC: RatingViewProtocol {
    func reloadRating() {
        tableView.reloadData()
    }
    
    func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
}


extension RatingVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.teams.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RatingCell.identifier, for: indexPath) as! RatingCell
        
        let team = presenter.teams[indexPath.row]
        cell.configure(with: team.name, games: team.games, points: team.points)
        
        return cell
    }
    
}
