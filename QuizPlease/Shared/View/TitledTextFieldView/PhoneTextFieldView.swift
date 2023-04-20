//
//  PhoneTextFieldView.swift
//  QuizPlease
//
//  Created by Владислав on 02.07.2021.
//  Copyright © 2021 Владислав. All rights reserved.
//

import UIKit
import PhoneNumberKit

enum PhoneNumberKitInstance {
    static let shared = PhoneNumberKit()
}

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

    // MARK: - State properties

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

    // MARK: - Private Properties

    private var currentRegion: String = ""
    private var currentRegionCode: String = ""
    private var leadingDigits: String = ""

    private let phoneTextField: PhoneNumberTextField = {
        let textField = PhoneNumberTextField(withPhoneNumberKit: PhoneNumberKitInstance.shared)
        textField.withFlag = true
        textField.withPrefix = true
        textField.withExamplePlaceholder = true
        textField.withDefaultPickerUI = true
        return textField
    }()

    // MARK: - Override Properties

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

    // MARK: - Private Methods

    private func updateCurentRegion(_ newRegion: String) {
        currentRegion = newRegion
        let code = phoneTextField.phoneNumberKit.countryCode(for: currentRegion) ?? 1
        currentRegionCode = "\(code)"
        leadingDigits = phoneTextField.phoneNumberKit.leadingDigits(for: currentRegion) ?? ""
    }

    // MARK: - Override Methods

    override func textFieldDidBeginEditing(_ textField: UITextField) {
        if isPhoneMaskEnabled {
            updateCurentRegion(phoneTextField.currentRegion)
            if textField.text == "+\(currentRegionCode)" {
                textField.text = nil
            }
        }

        super.textFieldDidBeginEditing(textField)
    }

    override func textFieldDidChange(_ textField: UITextField) {
        if isPhoneMaskEnabled {
            if phoneTextField.currentRegion != currentRegion {
                updateCurentRegion(phoneTextField.currentRegion)
            }
            if let text = textField.text, text.count == 1 {
                if leadingDigits.contains(text) || !text.matches(of: leadingDigits).isEmpty {
                    phoneTextField.text = "+\(currentRegionCode)\(text)"
                } else if text == "2" && currentRegionCode == "1" {
                    phoneTextField.text = "+\(currentRegionCode)\(text)"
                } else if text.allSatisfy({ $0.isWholeNumber }) {
                    phoneTextField.text = "+\(text)"
                }
            }
        }

        delegate?.textFieldView(self, didChangeTextField: extractedFormattedNumber)
    }

    override func textFieldDidEndEditing(_ textField: UITextField) {
        /// must call `super.textFieldDidEndEditing(_:)` to preserve correct behavior
        super.textFieldDidEndEditing(textField)
    }
}
