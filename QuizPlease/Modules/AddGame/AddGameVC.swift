//
//  AddGameVC.swift
//  QuizPlease
//
//  Created by Владислав on 26.08.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import UIKit

protocol AddGameVCDelegate: AnyObject {
    func didAddGameToUserProfile(_ vc: AddGameVC)
}

final class AddGameVC: UIViewController {

    // MARK: - Outlets
    @IBOutlet private weak var addGameButton: ScalingButton!
    @IBOutlet private weak var infoView: UIView!
    @IBOutlet private weak var gameNameLabel: UILabel!
    @IBOutlet private weak var gameNumberLabel: UILabel!
    @IBOutlet private weak var placeNameLabel: UILabel!
    @IBOutlet private weak var placeAddressLabel: UILabel!
    @IBOutlet private weak var timeLabel: UILabel!
    @IBOutlet private weak var chooseTeamView: TitledTextFieldView!

    var token: String!
    var teamsInfo = [TeamInfo]()
    var chosenTeam: TeamInfo?
    var gameInfo: GameInfo?

    weak var delegate: AddGameVCDelegate?

    // MARK: - Add Game Button Pressed
    @IBAction private func addGameButtonPressed(_ sender: Any) {
        saveGame()
        // navigationController?.popViewController(animated: true)
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareNavigationBar(barStyle: .transcluent(tintColor: view.backgroundColor))
        configureViews()
        setupData()
    }

    private func setupData() {
        setGameData()
        gameNameLabel.text = "Загрузка…"
        loadDataFromQR()
    }

    // MARK: - Save Game
    private func saveGame() {
        guard let id = chosenTeam?.id else {
            showSimpleAlert(title: "Команда не выбрана", message: "Пожалуйста, выберите команду, за которую Вы играли")
            return
        }
        guard gameInfo?.placeInfo.cityName == AppSettings.defaultCity.title else {
            showSimpleAlert(
                title: "Город игры не совпадает",
                message: "Город, в котором проводилась игра, должен совпадать с городом, " +
                "который указан на главном экране приложения"
            )
            return
        }
        checkUserLocation { [weak self] isSatisfactory in
            guard let self = self else { return }
            guard let isClose = isSatisfactory else {
                self.showSimpleAlert(title: "Не удалось проверить геолокацию")
                return
            }
            if isClose {
                self.checkIn(teamId: id)
            } else {
                self.showSimpleAlert(
                    title: "Вы находитесь слишком далеко",
                    message: "Чтобы добавить игру в Личный кабинет и получить за неё баллы, " +
                    "Вам необходимо быть в месте проведения игры"
                )
            }
        }
    }

    // MARK: - Check In
    private func checkIn(teamId id: Int) {
        NetworkService.shared.checkInOnGame(with: token, chosenTeamId: id) { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case let .failure(error):
                print(error)
                self.showErrorConnectingToServerAlert()
            case let .success(response):
                if response.message == "ok" {
                    self.delegate?.didAddGameToUserProfile(self)
                    self.navigationController?.popViewController(animated: true)
                } else if response.status == 400 {
                    self.showSimpleAlert(
                        title: "Ошибка",
                        message: response.message ?? "Неизвестная ошибка сервера"
                    )
                } else {
                    self.showErrorConnectingToServerAlert()
                }
            }
        }
    }

    // MARK: - Load From QR
    private func loadDataFromQR() {
        NetworkService.shared.getTeamsFromQR(token) { [weak self] (serverResult) in
            guard let self = self else { return }
            switch serverResult {
            case let .failure(error):
                print(error)
                self.gameNameLabel.text = "-"
                self.showSimpleAlert(
                    title: "Не удалось найти игру",
                    message: "Попробуйте отсканировать код ещё раз"
                ) { _ in
                    self.navigationController?.popViewController(animated: true)
                }
            case let .success(teams):
                self.teamsInfo = teams.filter(\.isConfirmed)
                self.loadGameInfo(with: teams[0].game_id)
            }
        }
    }

    // MARK: - Load Game
    private func loadGameInfo(with id: Int) {
        NetworkService.shared.getGameInfo(by: id) { [weak self] (serverResult) in
            guard let self = self else { return }
            switch serverResult {
            case let .failure(error):
                print(error)
                self.showErrorConnectingToServerAlert()
            case let.success(gameInfo):
                self.gameInfo = gameInfo
            }
            self.setGameData()
        }
    }

    // MARK: - Check User Location
    /// - parameter isSatisfactory: `true` - user location is close to the place location,
    /// `false` - user location is too far from the place location, `nil` - unavailable to get user loaction
    private func checkUserLocation(completion: @escaping (_ isSatisfactory: Bool?) -> Void) {
        UserLocationService.shared.askUserLocation { (location) in
            guard let gameInfo = self.gameInfo else { return }
            guard let location = location else {
                completion(nil)
                return
            }
            let isCloseToPlace = gameInfo.placeInfo.isCloseToLocation(location)
            completion(isCloseToPlace)
        }
    }

    // MARK: - Set Game Fata
    private func setGameData() {
        gameNameLabel.text = gameInfo?.nameGame ?? "-"
        gameNumberLabel.text = gameInfo?.gameNumber ?? "#"
        placeNameLabel.text = gameInfo?.placeInfo.title ?? "-"
        placeAddressLabel.text = gameInfo?.placeInfo.fullAddress  ?? "-"

        if let dateStr = gameInfo?.formattedDate, let time = gameInfo?.time {
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
