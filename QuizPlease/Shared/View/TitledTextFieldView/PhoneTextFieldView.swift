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

    /// Kind of formatting the phone number
    enum NumberFormattingKind {

        /// A number without country code, e.g. `9121234567` for +7 (912) 123-45-67
        case national

        /// A whole number with country code, e.g. `+79121234567` for +7 (912) 123-45-67
        case international

        /// A whole number with country code and a phone mask
        /// (as it appears in the View for the user),
        /// e.g. `+7 912 123-45-67` for +7 (912) 123-45-67
        case internationalWithMask
    }

    private let phoneTextField: PhoneNumberTextField = {
        let textField = PhoneNumberTextField()
        textField.withFlag = true
        textField.withPrefix = true
        textField.withExamplePlaceholder = true
        textField.withDefaultPickerUI = true
        return textField
    }()

    /// This property defines the way how does delegate method
    /// `textFieldView(_:didChangeTextField:didCompleteMask:)`
    /// return the '`didChangeTextField`' text parameter.
    var formattingKind: NumberFormattingKind = .international

    /// Extracts phone number from `PhoneNumberTextField` using format specified in `formattingKind` property
    var extractedFormattedNumber: String {
        switch formattingKind {
        case .national:
            return phoneTextField.nationalNumber
        case .international:
            guard let number = phoneTextField.phoneNumber else {
                return phoneTextField.text ?? ""
            }
            return "+\(number.countryCode)\(number.nationalNumber)"
        case .internationalWithMask:
            return phoneTextField.text ?? ""
        }
    }

    var isPhoneMaskEnabled: Bool {
        get { phoneTextField.isPartialFormatterEnabled }
        set {
            phoneTextField.isPartialFormatterEnabled = newValue
            phoneTextField.withFlag = newValue
            phoneTextField.withPrefix = newValue
            phoneTextField.withExamplePlaceholder = newValue
        }
    }

    var isValidNumber: Bool { phoneTextField.isValidNumber }

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
        delegate?.textFieldView(self, didChangeTextField: extractedFormattedNumber)
    }

    override func textFieldDidEndEditing(_ textField: UITextField) {
        /// must call `super.textFieldDidEndEditing(_:)` to preserve correct behavior
        super.textFieldDidEndEditing(textField)
    }
}
