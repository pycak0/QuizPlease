//
//  GameRegisterCell.swift
//  QuizPlease
//
//  Created by Владислав on 13.08.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import UIKit

//MARK:- Delegate Protocol
protocol GameRegisterCellDelegate: class {
    func registerCell(_ registerCell: GameRegisterCell, didChangeNumberOfPeopleInTeam number: Int)
}

class GameRegisterCell: UITableViewCell, TableCellProtocol {
    static let identifier = "GameRegisterCell"
    
    weak var delegate: GameRegisterCellDelegate?
    
    @IBOutlet weak var teamNameFieldView: TitledTextFieldView!
    @IBOutlet weak var captainNameFieldView: TitledTextFieldView!
    @IBOutlet weak var emailFieldView: TitledTextFieldView!
    @IBOutlet weak var phoneFieldView: TitledTextFieldView!
    @IBOutlet weak var fieldsStack: UIStackView!
    @IBOutlet weak var numberButtonsStack: UIStackView!
    @IBOutlet weak var feedbackFieldView: TitledTextFieldView!
    
    //MARK:- Layout Subviews
    override func layoutSubviews() {
        super.layoutSubviews()
        configureViews()
    }
    
    //MARK:- Configure Views
    func configureViews() {
        numberButtonsStack.arrangedSubviews.forEach {
            $0.layer.cornerRadius = $0.frame.height / 2
        }
        
        for (index, field) in (fieldsStack.arrangedSubviews as! [TitledTextFieldView]).enumerated() {
            field.textField.delegate = self
            if let type = TextFieldType(rawValue: index) {
                field.textField.textContentType = type.contentType
                field.textField.autocapitalizationType = type.capitalizationType
                field.textField.keyboardType = type.keyboardType
                field.textField.returnKeyType = .done
            }
        }
        feedbackFieldView.textField.delegate = self
        feedbackFieldView.textField.autocapitalizationType = .sentences
        feedbackFieldView.textField.returnKeyType = .done
    }
    
    //MARK:- Team Count Button Pressed
    @IBAction func teamCountButtonPressed(_ sender: UIButton) {
        guard let index = numberButtonsStack.arrangedSubviews.firstIndex(of: sender) else {
            return
        }
        numberButtonsStack.arrangedSubviews.forEach {
            let button = $0 as? UIButton
            deselect(button)
        }
        let number = Int(index) + 1
        delegate?.registerCell(self, didChangeNumberOfPeopleInTeam: number)
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

//MARK:- UITextFieldDelegate
extension GameRegisterCell: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        true
    }
}


//MARK:- Text Field Types
fileprivate enum TextFieldType: Int, CaseIterable {
    case team, captain, email, phone
    
    var contentType: UITextContentType {
        switch self {
        case .team:
            return .nickname
        case .captain:
            return .name
        case .email:
            return .emailAddress
        case .phone:
            return .telephoneNumber
        }
    }
    
    var keyboardType: UIKeyboardType {
        switch self {
        case .email:
            return .emailAddress
        case .phone:
            return .phonePad
        default:
            return .default
        }
    }
    
    var capitalizationType: UITextAutocapitalizationType {
        switch self {
        case .team:
            return .sentences
        case .captain:
            return .words
        default:
            return .none
        }
    }
}
