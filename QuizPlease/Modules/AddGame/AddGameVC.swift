//
//  AddGameVC.swift
//  QuizPlease
//
//  Created by Владислав on 26.08.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import UIKit

class AddGameVC: UIViewController {
    
    //MARK:- Outlets
    @IBOutlet weak var addGameButton: ScalingButton!
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var gameNameLabel: UILabel!
    @IBOutlet weak var gameNumberLabel: UILabel!
    @IBOutlet weak var placeNameLabel: UILabel!
    @IBOutlet weak var placeAddressLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var chooseTeamView: TitledTextFieldView!
    
    var token: String!
    
    var teamsInfo = [TeamInfo]()
    
    var chosenTeam: TeamInfo?
    
    //MARK:- Add Game Button Pressed
    @IBAction func addGameButtonPressed(_ sender: Any) {
        saveGame()
        //navigationController?.popViewController(animated: true)
    }
    
    //MARK:- Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareNavigationBar()
        configureViews()
        setupData()
    }
    
    
    private func setupData() {
        setGameData(nil)
        gameNameLabel.text = "Загрузка…"
        loadDataFromQR()
    }
    
    //MARK:- Save Game
    private func saveGame() {
        guard let id = chosenTeam?.id else {
            showSimpleAlert(title: "Команда не выбрана", message: "Пожалуйста, выберите команду, за которую Вы играли")
            return
        }
        NetworkService.shared.checkInOnGame(with: token, chosenTeamId: id) { [weak self] (isSuccess) in
            guard let self = self else { return }
            if isSuccess {
                self.navigationController?.popViewController(animated: true)
            } else {
                self.showErrorConnectingToServerAlert()
            }
        }
    }
        
    //MARK:- Load From QR
    private func loadDataFromQR() {
        NetworkService.shared.getTeamsFromQR(token) { [weak self] (serverResult) in
            guard let self = self else { return }
            switch serverResult {
            case let .failure(error):
                print(error)
                self.gameNameLabel.text = "-"
                self.showSimpleAlert(title: "Не удалось найти игру",
                                     message: "Попробуйте отсканировать код ещё раз") { _ in
                    self.navigationController?.popViewController(animated: true)
                }
            case let .success(teams):
                self.teamsInfo = teams
                self.loadGameInfo(with: teams[0].game_id)
            }
        }
    }
    
    //MARK:- Load Game
    private func loadGameInfo(with id: Int) {
        NetworkService.shared.getGameInfo(by: id) { [weak self] (serverResult) in
            guard let self = self else { return }
            var gameData: GameInfo?
            switch serverResult {
            case let .failure(error):
                print(error)
                self.showErrorConnectingToServerAlert()
            case let.success(gameInfo):
                gameData = gameInfo
            }
            self.setGameData(gameData)
        }
    }
    
    //MARK:- Set Game Fata
    private func setGameData(_ model: GameInfo?) {
        gameNameLabel.text = model?.nameGame ?? "-"
        gameNumberLabel.text = model?.gameNumber ?? "#"
        placeNameLabel.text = model?.placeInfo.title ?? "-"
        placeAddressLabel.text = model?.placeInfo.shortAddress  ?? "-"
        
        if let dateStr = model?.blockData, let time = model?.time {
            timeLabel.text = "\(dateStr) в \(time)"
        } else {
            timeLabel.text = "-"
        }
        
    }
    
    private func configureViews() {
        infoView.layer.borderColor = UIColor.systemGreen.cgColor
        infoView.layer.borderWidth = 4
        infoView.layer.cornerRadius = 20
        
        addGameButton.layer.cornerRadius = 20
        addGameButton.addGradient(colors: [.lemon, .lightOrange], insertAt: 0)
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(didPressChooseTeam))
        chooseTeamView.addGestureRecognizer(tapRecognizer)
        chooseTeamView.textField.isEnabled = false
    }
    
    @objc
    private func didPressChooseTeam() {
        guard teamsInfo.count > 0 else { return }
        let names = teamsInfo.map { $0.teamName }
        showChooseItemActionSheet(itemNames: names) { [unowned self] (teamName, index) in
            self.chooseTeamView.textField.text = teamName
            self.chosenTeam = self.teamsInfo[index]
        }
    }

}
