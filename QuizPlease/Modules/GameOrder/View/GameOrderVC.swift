//
//  GameOrderVC.swift
//  QuizPlease
//
//  Created by Владислав on 12.08.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import UIKit

protocol GameOrderViewProtocol: UIViewController {
    var presenter: GameOrderPresenterProtocol! { get set }
    var configurator: GameOrderConfiguratorProtocol! { get }
    
    func reloadInfo()
    func configureTableView()
}

class GameOrderVC: UIViewController {
    let configurator: GameOrderConfiguratorProtocol! = GameOrderConfigurator()
    var presenter: GameOrderPresenterProtocol!
    
    @IBOutlet weak var gameImageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
        
    //MARK:- Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.configureViews()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        presenter.router.prepare(for: segue, sender: sender)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }

    func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        for cellKind in GameInfoItemKind.allCases {
            tableView.register(UINib(nibName: cellKind.identifier, bundle: nil), forCellReuseIdentifier: cellKind.identifier)
        }
        
    }

}

extension GameOrderVC: GameOrderViewProtocol {
    func reloadInfo() {
        tableView.reloadData()
    }
    
}


//MARK:- Data Source & Delegate
extension GameOrderVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return GameInfoItemKind.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //createCell(tableView, at: indexPath)
        guard let kind = GameInfoItemKind(rawValue: indexPath.row) else { fatalError("Invalid Game Item Kind") }
        let cell = tableView.dequeueReusableCell(withIdentifier: kind.identifier, for: indexPath) as! TableCellProtocol
        
        return cell
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        guard let kind = GameInfoItemKind(rawValue: indexPath.row) else { return 44 }
//
//        return kind.height
//    }
    
}

extension GameOrderVC: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.y + scrollView.safeAreaInsets.top
        guard offset < 0, scrollView.isKind(of: UITableView.self) else {
            gameImageView.transform = .identity
            return
        }
        let scale = (1 + abs(offset) / 500)
        gameImageView.transform = CGAffineTransform(scaleX: scale, y: scale)
    }
}
