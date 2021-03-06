//
//  PhoneTextFieldView.swift
//  QuizPlease
//
//  Created by Владислав on 02.07.2021.
//  Copyright © 2021 Владислав. All rights reserved.
//

import UIKit
import PhoneNumberKit

@IBDesignable
class PhoneTextFieldView: TitledTextFieldView {
    enum NumberFormattingKind {
        ///A number without country code, e.g. `9121234567` for +7 (912) 123-45-67
        case national
        ///A whole number with country code, e.g. `+79121234567` for +7 (912) 123-45-67
        case international
    }
    
    private let phoneTextField: PhoneNumberTextField = {
        let textField = PhoneNumberTextField()
        textField.withFlag = true
        textField.withPrefix = true
        textField.withExamplePlaceholder = true
        return textField
    }()
    
    ///This property defines the way how does delegate method `textFieldView(_:didChangeTextField:didCompleteMask:)` return the '`didChangeTextField`' text parameter
    var formattingKind: NumberFormattingKind = .international
    
    var isPhoneMaskEnabled: Bool {
        get { phoneTextField.isPartialFormatterEnabled }
        set {
            phoneTextField.isPartialFormatterEnabled = newValue
            phoneTextField.withFlag = newValue
            phoneTextField.withPrefix = newValue
            phoneTextField.withExamplePlaceholder = newValue
        }
    }
    
    override var textField: UITextField {
        get { phoneTextField } set {}
    }
    
    override var placeholder: String {
        get { phoneTextField.placeholder ?? super.placeholder }
        set {
            guard !phoneTextField.withExamplePlaceholder else { return }
            super.placeholder = newValue
        }
    }
    
    override func textFieldDidChange(_ textField: UITextField) {
        let text: String = {
            switch formattingKind {
            case .national:
                return phoneTextField.nationalNumber
            case .international:
                guard let number = phoneTextField.phoneNumber else { return phoneTextField.text ?? "" }
                return "+\(number.countryCode)\(number.nationalNumber)"
            }
        }()
        delegate?.textFieldView(self, didChangeTextField: text, didCompleteMask: phoneTextField.isValidNumber)
    }
    
    override func textFieldDidEndEditing(_ textField: UITextField) {
        delegate?.textFieldViewDidEndEditing(self)
    }
}
