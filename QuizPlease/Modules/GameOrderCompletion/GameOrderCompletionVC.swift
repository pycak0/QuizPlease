//
//  GameOrderCompletionVC.swift
//  QuizPlease
//
//  Created by Владислав on 19.09.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import UIKit

//MARK:- Delegate Protocol
protocol GameOrderCompletionDelegate: class {
    func didPressDismissButton(in vc: GameOrderCompletionVC)
}

class GameOrderCompletionVC: UIViewController {
    
    enum RowKind: Int, CaseIterable {
        case info = 0, people = 1
    }
    
    weak var delegate: GameOrderCompletionDelegate?
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet weak var bottomView: UIView!
    
    var gameInfo: GameInfo!
    var numberOfPeopleInTeam: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareNavigationBar(title: gameInfo.fullTitle)
        configureViews()
    }
    
    private func configureViews() {
        tableView.register(UINib(nibName: GameInfoCell.identifier, bundle: nil), forCellReuseIdentifier: GameInfoCell.identifier)
        tableView.register(UINib(nibName: GOCPeopleNumberCell.identifier, bundle: nil), forCellReuseIdentifier: GOCPeopleNumberCell.identifier)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        bottomView.backgroundColor = .clear
        //bottomView.blurView.setup(style: .regular, alpha: 1).enable()
    }

    @IBAction func okButtonPressed(_ sender: Any) {
        delegate?.didPressDismissButton(in: self)
    }
}


//MARK:- Data Source & Delegate
extension GameOrderCompletionVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return RowKind.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let sectionKind = RowKind(rawValue: indexPath.row) else { fatalError("Invalid Section Kind") }
        
        switch sectionKind {
        case .info:
            let cell = tableView.dequeueReusableCell(withIdentifier: GameInfoCell.identifier, for: indexPath) as! GameInfoCell
            cell.cellView.layer.borderWidth = 4
            cell.cellView.layer.borderColor = UIColor.lightGreen.cgColor
            cell.mapView.isUserInteractionEnabled = false
            cell.availablePlacesStack.isHidden = true
            cell.delegate = self
            return cell
        case .people:
            let cell = tableView.dequeueReusableCell(withIdentifier: GOCPeopleNumberCell.identifier, for: indexPath) as! GOCPeopleNumberCell
            cell.setNumber(numberOfPeopleInTeam)
            return cell
        }
    }
    
}

//MARK:- GameInfoCellDelegate
extension GameOrderCompletionVC: GameInfoCellDelegate {
    func gameInfo(for gameInfoCell: GameInfoCell) -> GameInfo {
        return gameInfo
    }
}
