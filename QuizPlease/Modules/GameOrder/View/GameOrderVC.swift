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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }

    func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: GameAnnotationCell.identifier, bundle: nil), forCellReuseIdentifier: GameAnnotationCell.identifier)
        tableView.register(UINib(nibName: GameInfoCell.identifier, bundle: nil), forCellReuseIdentifier: GameInfoCell.identifier)
        tableView.register(UINib(nibName: GameGeneralDescriptionCell.identifier, bundle: nil), forCellReuseIdentifier: GameGeneralDescriptionCell.identifier)
        tableView.register(UINib(nibName: GameRegisterCell.identifier, bundle: nil), forCellReuseIdentifier: GameRegisterCell.identifier)
        tableView.register(UINib(nibName: GameCertificateCell.identifier, bundle: nil), forCellReuseIdentifier: GameCertificateCell.identifier)
        
    }
    
    func createCell(_ tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
        guard let kind = GameInfoItemKind(rawValue: indexPath.row) else { fatalError("Invalid Game Item Kind") }
        
        var cell = tableView.dequeueReusableCell(withIdentifier: kind.identifier, for: indexPath)
        switch kind {
        case .annotation:
             cell = cell as! GameAnnotationCell
        case .info:
             cell = cell as! GameInfoCell
        case .registration:
             cell = cell as! GameRegisterCell
        case .description:
             cell = cell as! GameGeneralDescriptionCell
        case .certificate:
             cell = cell as! GameCertificateCell
        }
        print(type(of: cell))
        return cell
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
        createCell(tableView, at: indexPath)
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
        print(scrollView.safeAreaInsets.top)
        let scale = (1 + abs(offset) / 500)
        gameImageView.transform = CGAffineTransform(scaleX: scale, y: scale)
    }
}
