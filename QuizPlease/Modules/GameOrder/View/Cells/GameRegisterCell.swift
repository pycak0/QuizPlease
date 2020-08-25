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

class GameRegisterCell: UITableViewCell, GameOrderCellProtocol {
    static let identifier = "GameRegisterCell"
    
    weak var delegate: AnyObject? {
        get { _delegate }
        set { _delegate = newValue as? GameRegisterCellDelegate }
    }
    private weak var _delegate: GameRegisterCellDelegate?
    
    @IBOutlet weak var teamNameFieldView: TitledTextFieldView!
    @IBOutlet weak var captainNameFieldView: TitledTextFieldView!
    @IBOutlet weak var emailFieldView: TitledTextFieldView!
    @IBOutlet weak var phoneFieldView: TitledTextFieldView!
    @IBOutlet weak var fieldsStack: UIStackView!
    @IBOutlet weak var numberButtonsStack: UIStackView!
    @IBOutlet weak var feedbackFieldView: TitledTextFieldView!
    
    var selectedNumberOfPeople: Int = 2
    let startCount = 2
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureTextFields()
        select(numberButtonsStack.arrangedSubviews.first as! UIButton, number: selectedNumberOfPeople)
    }
    
    //MARK:- Layout Subviews
    override func layoutSubviews() {
        super.layoutSubviews()
        configureViews()
    }
    
    //MARK:- Team Count Button Pressed
    @IBAction func teamCountButtonPressed(_ sender: UIButton) {
        guard let index = numberButtonsStack.arrangedSubviews.firstIndex(of: sender),
            index + startCount != selectedNumberOfPeople else {
            return
        }
        selectedNumberOfPeople = index + startCount
        _delegate?.registerCell(self, didChangeNumberOfPeopleInTeam: selectedNumberOfPeople)
        numberButtonsStack.arrangedSubviews.forEach {
            let button = $0 as? UIButton
            deselect(button)
        }
        select(sender, number: selectedNumberOfPeople)
    }
    
    //MARK:- Configure Views
    func configureViews() {
        numberButtonsStack.arrangedSubviews.forEach {
            $0.layer.cornerRadius = $0.frame.height / 2
        }
    }
    
    func configureTextFields() {
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
    
    //MARK:- Select
    func select(_ button: UIButton, number: Int) {
        let scale: CGFloat = 1.1
        UIView.animate(withDuration: 0.2) {
            button.setTitle("\(number)", for: .normal)
            button.setImage(nil, for: .normal)
            button.backgroundColor = .systemBlue
            button.transform = CGAffineTransform(scaleX: scale, y: scale)
        }
    }
    
    //MARK:- Deselect
    func deselect(_ button: UIButton?) {
        var color = UIColor.themeGray
        if #available(iOS 13.0, *) {
            color = .systemGray5
        }
        UIView.animate(withDuration: 0.2) {
            button?.setImage(UIImage(named: "human"), for: .normal)
            button?.setTitle("", for: .normal)
            button?.backgroundColor = color
            button?.transform = .identity
        }
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
