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
    var presenter: ProfilePresenterProtocol! { get set }
    
    func configureViews()
    
    func reloadGames()
    
    func updateUserInfo(with pointsScored: Int)
}

class ProfileVC: UIViewController {
    var presenter: ProfilePresenterProtocol!

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var infoHeader: UIView!
    @IBOutlet weak var gamesCountLabel: UILabel!
    @IBOutlet weak var totalPointsScoredLabel: UILabel!
    @IBOutlet weak var showShopButton: UIButton!
    @IBOutlet weak var addGameButton: ScalingButton!
    
    //`addGameButton` fading helpers
    var lastOffset: CGFloat = 0
    var startOffset: CGFloat?
    
    override func viewDidLoad() {
        super.viewDidLoad()
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

//MARK:- View Protocol Implementation
extension ProfileVC: ProfileViewProtocol {
    func configureViews() {
        tableView.delegate = self
        tableView.dataSource = self
        
        infoHeader.addGradient(colors: [.lemon, .lightOrange], insertAt: 0)
        totalPointsScoredLabel.layer.cornerRadius = totalPointsScoredLabel.bounds.height / 2
        showShopButton.layer.cornerRadius = showShopButton.bounds.height / 2
        
        addGameButton.layer.cornerRadius = 20
        addGameButton.addGradient(colors: [.lemon, .lightOrange], insertAt: 0)
    }
    
    func reloadGames() {
        tableView.reloadSections(IndexSet(arrayLiteral: 0), with: .automatic)
    }
    
    func updateUserInfo(with pointsScored: Int) {
        let gamesCount = presenter.userInfo?.games?.count ?? 0
        totalPointsScoredLabel.text = pointsScored.string(withAssociatedMaleWord: "балл")
        let gamesFormattedCount = gamesCount.string(withAssociatedFirstCaseWord: "игра")
        gamesCountLabel.text = "Вы сходили на \(gamesFormattedCount) и накопили"
    }
}

//MARK:- QR Scanner VC Delegate
extension ProfileVC: QRScannerVCDelegate {
    func qrScanner(_ qrScanner: QRScannerVC, didFinishCodeScanningWith result: String?) {
        guard let code = result else { return }
        presenter.didAddNewGame(with: code)
    }
}

//MARK:- Data Source & Delegate
extension ProfileVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.userInfo?.games?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ProfileCell.identifier, for: indexPath) as! ProfileCell
        
        guard let game = presenter.userInfo?.games?[indexPath.row] else { return cell }
        
        cell.configure( gameName:       game.name,
                        gameNumber:     game.title,
                        teamName:       "",
                        place:          game.place,
                        pointsScored:   0)
        
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
