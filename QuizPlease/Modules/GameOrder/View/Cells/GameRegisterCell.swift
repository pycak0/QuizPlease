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
    ///The delegate should return a  number of people to select in picker. If the number is invalid, picker will select the first button.
    func selectedNumberOfPeople(in registerCell: GameRegisterCell) -> Int
    
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
    @IBOutlet weak var countPicker: CountPickerView!
    @IBOutlet weak var feedbackFieldView: TitledTextFieldView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureCell()
    }
    
    //MARK:- Layout Subviews
    override func layoutSubviews() {
        super.layoutSubviews()
        countPicker.buttonsCornerRadius = 15
        guard let number = _delegate?.selectedNumberOfPeople(in: self) else { return }
        let index = number - countPicker.startCount
        countPicker.setSelectedButton(at: index)
    }
    
    private func configureCell() {
        configurePicker()
        configureTextFields()
    }
    
    private func configurePicker() {
        countPicker.delegate = self
        let font = UIFont(name: "Gilroy-SemiBold", size: 16)!
        countPicker.titleLabel.font = font
        countPicker.buttonsTitleFont = font
    }
    
    private func configureTextFields() {
        for (index, field) in (fieldsStack.arrangedSubviews as! [TitledTextFieldView]).enumerated() {
            field.delegate = self
            if let type = TextFieldType(rawValue: index) {
                field.textField.textContentType = type.contentType
                field.textField.autocapitalizationType = type.capitalizationType
                field.textField.keyboardType = type.keyboardType
                field.textField.returnKeyType = .done
            }
        }
        feedbackFieldView.delegate = self
        feedbackFieldView.textField.autocapitalizationType = .sentences
        feedbackFieldView.textField.returnKeyType = .done
    }
    
}

//MARK:- TitledTextFieldViewDelegate
extension GameRegisterCell: TitledTextFieldViewDelegate {
    func textFieldView(_ textFieldView: TitledTextFieldView, didChangeTextField text: String, didCompleteMask isComplete: Bool) {
        //
    }
}

//MARK:- CountPickViewDelegate
extension GameRegisterCell: CountPickerViewDelegate {
    func countPicker(_ picker: CountPickerView, didChangeSelectedNumber number: Int) {
        _delegate?.registerCell(self, didChangeNumberOfPeopleInTeam: number)
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
