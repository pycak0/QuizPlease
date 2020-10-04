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
    
    func configureViews()
}

class ProfileVC: UIViewController {
    let configurator: ProfileConfiguratorProtocol = ProfileConfigurator()
    var presenter: ProfilePresenterProtocol!

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var infoHeader: UIView!
    @IBOutlet weak var gamesCountLabel: UILabel!
    @IBOutlet weak var totalPointsScored: UILabel!
    @IBOutlet weak var showShopButton: UIButton!
    @IBOutlet weak var addGameButton: ScalingButton!
    
    //`addGameButton` fading helpers
    var lastOffset: CGFloat = 0
    var startOffset: CGFloat?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configurator.configure(self)
        presenter.setupView()

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        presenter.router.prepare(for: segue, sender: sender)
    }

    @IBAction func shopButtonPressed(_ sender: UIButton) {
        //sender.scaleOut()
        presenter.didPressShowShopButton()
    }
    
    @IBAction func addGameButtonPressed(_ sender: UIButton) {
        sender.scaleOut()
        presenter.didPressAddGameButton()
    }

}

//MARK:- Protocol Implementation
extension ProfileVC: ProfileViewProtocol {
    func configureViews() {
        tableView.delegate = self
        tableView.dataSource = self
        
        infoHeader.addGradient(colors: [.lemon, .lightOrange], insertAt: 0)
        totalPointsScored.layer.cornerRadius = totalPointsScored.bounds.height / 2
        showShopButton.layer.cornerRadius = showShopButton.bounds.height / 2
        
        addGameButton.layer.cornerRadius = 20
        addGameButton.addGradient(colors: [.lemon, .lightOrange], insertAt: 0)
    }
}

extension ProfileVC: QRScannerVCDelegate {
    func qrScanner(_ qrScanner: QRScannerVC, didFinishCodeScanningWith result: String?) {
        guard let code = result else { return }
        presenter.didAddNewGame(with: code)
    }
}

//MARK:- Data Source & Delegate
extension ProfileVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //let count = 3
        let count = presenter.games.count
        let gamesFormattedCount = count.string(withAssociatedFirstCaseWord: "игра")
        gamesCountLabel.text = "Вы сходили на \(gamesFormattedCount) и накопили"
        
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ProfileCell.identifier, for: indexPath) as! ProfileCell
        
        //let game = presenter.games[indexPath.row]
        //let number = indexPath.row + 1
//        cell.configure( gameName:       "Game\(number)",
//                        gameNumber:     number,
//                        teamName:       "Team\(number)",
//                        place:          number,
//                        pointsScored:   10 * indexPath.row + number)
        
        return cell
    }
    
}


//MARK:- UIScrollViewDelegate
extension ProfileVC: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentOffset = scrollView.contentOffset.y + scrollView.safeAreaInsets.top
        let isScrollingDown = currentOffset > lastOffset
        //print(currentOffset)
        
        if isScrollingDown && currentOffset > 10 {
            if startOffset == nil {
                startOffset = currentOffset
            }
            let translation = currentOffset - startOffset!
            let alpha: CGFloat = max(0, (100 - currentOffset + startOffset!) / 100)
            if addGameButton.alpha > 0 {
                addGameButton.alpha = alpha
                addGameButton.transform = CGAffineTransform(translationX: 0, y: translation)
            }
        } else {
            UIView.animate(withDuration: 0.15) {
                self.addGameButton.alpha = 1
                self.addGameButton.transform = .identity
            }
            startOffset = nil
        }
        
        lastOffset = currentOffset

    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        guard !decelerate, addGameButton.alpha != 0 && addGameButton.alpha != 1 else { return }
        
        let transform = addGameButton.alpha >= 0.5 ? CGAffineTransform.identity : CGAffineTransform(translationX: 0, y: 100)
        let alpha = addGameButton.alpha.rounded()
        startOffset = alpha == 1 ? nil : startOffset
        
        UIView.animate(withDuration: 0.2) {
            self.addGameButton.transform = transform
            self.addGameButton.alpha = alpha
        }
        
    }
}
