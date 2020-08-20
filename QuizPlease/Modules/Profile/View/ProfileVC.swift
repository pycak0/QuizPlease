//
//MARK:  ProfileVC.swift
//  QuizPlease
//
//  Created by Владислав on 30.07.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import UIKit

//MARK:- View Protocol
protocol ProfileViewProtocol: UIViewController {
    var configurator: ProfileConfiguratorProtocol { get }
    var presenter: ProfilePresenterProtocol! { get set }
    
    func configureTableView()
}

class ProfileVC: UIViewController {
    let configurator: ProfileConfiguratorProtocol = ProfileConfigurator()
    var presenter: ProfilePresenterProtocol!

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var infoHeader: UIView!
    @IBOutlet weak var gamesCountLabel: UILabel!
    @IBOutlet weak var totalPointsScored: UILabel!
    @IBOutlet weak var showShopButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configurator.configure(self)
        presenter.configureViews()

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        presenter.router.prepare(for: segue, sender: sender)
    }

    @IBAction func shopButtonPressed(_ sender: Any) {
        presenter.didPressShowShopButton()
    }
    
}

//MARK:- Protocol Implementation
extension ProfileVC: ProfileViewProtocol {
    func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        infoHeader.addGradient(colors: [.lemon, .lightOrange], insertAt: 0)
        totalPointsScored.layer.cornerRadius = totalPointsScored.bounds.height / 2
        showShopButton.layer.cornerRadius = showShopButton.bounds.height / 2
    }
}

//MARK:- Data Source & Delegate
extension ProfileVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = 3
        //let count = presenter.games.count
        let gamesFormattedCount = count.string(withAssociatedFirstCaseWord: "игра")
        gamesCountLabel.text = "Вы сходили на \(gamesFormattedCount) игр и накопили"
        
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ProfileCell.identifier, for: indexPath) as! ProfileCell
        
        //let game = presenter.game[indexPath.row]
        let number = indexPath.row + 1
        cell.configure( gameName:       "Game\(number)",
                        gameNumber:     number,
                        teamName:       "Team\(number)",
                        place:          number,
                        pointsScored:   10 * indexPath.row + number)
        
        return cell
    }
    
}
