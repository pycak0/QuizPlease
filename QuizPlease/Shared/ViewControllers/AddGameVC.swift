//
//  AddGameVC.swift
//  QuizPlease
//
//  Created by Владислав on 26.08.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import UIKit

class AddGameVC: UIViewController {
    
    @IBOutlet weak var addGameButton: ScalingButton!
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var gameNameLabel: UILabel!
    @IBOutlet weak var gameNumberLabel: UILabel!
    @IBOutlet weak var placeNameLabel: UILabel!
    @IBOutlet weak var placeAddressLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var chooseTeamView: TitledTextFieldView!
    
    var gameName: String!
    
    
    @IBAction func addGameButtonPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareNavigationBar()
        configureViews()
        setupData()
    }
    
    private func setupData() {
        gameNameLabel.text = gameName
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
        showChooseTeamActionSheet(teamNames: ["team1", "team2"]) { [unowned self] (teamName) in
            self.chooseTeamView.textField.text = teamName
        }
    }

}
