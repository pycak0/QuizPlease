//
//  MaskedTextFieldView.swift
//  QuizPlease
//
//  Created by Владислав on 02.07.2021.
//  Copyright © 2021 Владислав. All rights reserved.
//

import UIKit
import InputMask

private protocol MaskedTextFieldEditingListener: AnyObject {
    func onEditingChanged(in textField: UITextField)
}

private protocol MaskedTextFieldEndEditingListener: AnyObject {
    func onEndEditing(in textField: UITextField)
}

private class NotifyingMaskedTextFieldDelegate: MaskedTextFieldDelegate {
    weak var editingListener: MaskedTextFieldEditingListener?
    weak var endEditingListener: MaskedTextFieldEndEditingListener?

    override func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String
    ) -> Bool {
        defer { self.editingListener?.onEditingChanged(in: textField) }
        return super.textField(textField, shouldChangeCharactersIn: range, replacementString: string)
    }

    override func textFieldDidEndEditing(_ textField: UITextField) {
        defer { self.endEditingListener?.onEndEditing(in: textField) }
        return super.textFieldDidEndEditing(textField)
    }
}

@IBDesignable
class MaskedTextFieldView: TitledTextFieldView {
    static let noMask = "[…]"

    private let maskDelegate = NotifyingMaskedTextFieldDelegate()

    /// Make sure that mask satisfies the syntax described here:
    /// https://github.com/RedMadRobot/input-mask-ios/wiki/1.-Mask-Syntax
    @IBInspectable
    var inputMask: String = MaskedTextFieldView.noMask {
        didSet {
            maskDelegate.primaryMaskFormat = inputMask
            checkListener()
        }
    }

    lazy var isMaskComplete: Bool = {
        inputMask == Self.noMask
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
    }

    // MARK: - Configure
    private func configure() {
        textField.delegate = maskDelegate
        maskDelegate.endEditingListener = self
        if inputMask != maskDelegate.primaryMaskFormat {
            maskDelegate.primaryMaskFormat = inputMask
        }
        checkListener()
    }

    private func checkListener() {
        if maskDelegate.primaryMaskFormat == Self.noMask {
            maskDelegate.editingListener = self
            maskDelegate.listener = nil
        } else {
            maskDelegate.editingListener = nil
            maskDelegate.listener = self
        }
    }
}

// MARK: - MaskedTextFieldDelegateListener

extension MaskedTextFieldView: MaskedTextFieldDelegateListener,
                               MaskedTextFieldEditingListener,
                               MaskedTextFieldEndEditingListener {

    func onEndEditing(in textField: UITextField) {
        /// must call `super.textFieldDidEndEditing(_:)` to preserve correct behavior
        super.textFieldDidEndEditing(textField)
    }

    func onEditingChanged(in textField: UITextField) {
        guard inputMask == Self.noMask else { return }
        delegate?.textFieldView(self, didChangeTextField: textField.text ?? "")
    }

    func textField(
        _ textField: UITextField,
        didFillMandatoryCharacters isComplete: Bool,
        didExtractValue value: String
    ) {
        isMaskComplete = isComplete
        delegate?.textFieldView(self, didChangeTextField: value)
    }
}
