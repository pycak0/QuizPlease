//
//  GameOrderVC.swift
//  QuizPlease
//
//  Created by Владислав on 12.08.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import UIKit

class GameOrderVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    //MARK:- Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
    }

    func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(GameAnnotationCell.self, forCellReuseIdentifier: GameAnnotationCell.identifier)
        tableView.register(GameInfoCell.self, forCellReuseIdentifier: GameInfoCell.identifier)
    }

}


//MARK:- Data Source & Delegate
extension GameOrderVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        UITableViewCell()
    }
    
}
