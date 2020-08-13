//
//  GameRegisterCell.swift
//  QuizPlease
//
//  Created by Владислав on 13.08.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import UIKit

class GameRegisterCell: UITableViewCell, TableCellProtocol {
    static let identifier = "GameRegisterCell"
    
    @IBOutlet weak var teamNameField: TitledTextFieldView!
    @IBOutlet weak var captainNameField: TitledTextFieldView!
    @IBOutlet weak var emailField: TitledTextFieldView!
    @IBOutlet weak var phoneField: TitledTextFieldView!
    @IBOutlet weak var fieldsStack: UIStackView!
    @IBOutlet weak var numberButtonsStack: UIStackView!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        configureViews()
    }
    
    func configureViews() {
        numberButtonsStack.arrangedSubviews.forEach {
            $0.layer.cornerRadius = $0.frame.height / 2
        }
    }
    
    @IBAction func teamCountButtonPressed(_ sender: UIButton) {
        guard let index = numberButtonsStack.arrangedSubviews.firstIndex(of: sender) else {
            return
        }
        let number = Int(index) + 1
        numberButtonsStack.arrangedSubviews.forEach {
            let button = $0 as? UIButton
            deselect(button)
        }
        select(sender, number: number)
    }
    
    func select(_ button: UIButton, number: Int) {
        button.setTitle("\(number)", for: .normal)
        button.setImage(nil, for: .normal)
        button.backgroundColor = .systemBlue
    }
    
    func deselect(_ button: UIButton?) {
        button?.setImage(UIImage(named: "human"), for: .normal)
        button?.setTitle("", for: .normal)
        button?.backgroundColor = .themeGray
    }
    
}
