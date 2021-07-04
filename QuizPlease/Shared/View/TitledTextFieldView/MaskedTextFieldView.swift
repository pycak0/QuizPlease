//
//  MaskedTextFieldView.swift
//  QuizPlease
//
//  Created by Владислав on 02.07.2021.
//  Copyright © 2021 Владислав. All rights reserved.
//

import UIKit
import InputMask

protocol NotifyingMaskedTextFieldDelegateListener: AnyObject {
    func onEditingChanged(in textField: UITextField)
    func onEndEditing(in textField: UITextField)
}

class NotifyingMaskedTextFieldDelegate: MaskedTextFieldDelegate {
    weak var editingListener: NotifyingMaskedTextFieldDelegateListener?
    
    override func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        defer { self.editingListener?.onEditingChanged(in: textField) }
        return super.textField(textField, shouldChangeCharactersIn: range, replacementString: string)
    }
    
    override func textFieldDidEndEditing(_ textField: UITextField) {
        defer { self.editingListener?.onEndEditing(in: textField) }
        return super.textFieldDidEndEditing(textField)
    }
}

@IBDesignable
class MaskedTextFieldView: TitledTextFieldView {
    static let noMask = "[…]"
    
    private let listener = NotifyingMaskedTextFieldDelegate()
    
    ///Make sure that mask satisfies the syntax described here:
    ///https://github.com/RedMadRobot/input-mask-ios/wiki/1.-Mask-Syntax
    @IBInspectable
    var inputMask: String = MaskedTextFieldView.noMask {
        didSet {
            listener.primaryMaskFormat = inputMask
            checkListener()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
    }
    
    //MARK:- Configure
    private func configure() {
        textField.delegate = listener
        if inputMask != listener.primaryMaskFormat {
            listener.primaryMaskFormat = inputMask
        }
        checkListener()
    }
    
    private func checkListener() {
        if listener.primaryMaskFormat == Self.noMask {
            listener.editingListener = self
            listener.listener = nil
        } else {
            listener.editingListener = nil
            listener.listener = self
        }
    }
}

//MARK:- MaskedTextFieldDelegateListener
extension MaskedTextFieldView: MaskedTextFieldDelegateListener, NotifyingMaskedTextFieldDelegateListener {
    func onEndEditing(in textField: UITextField) {
        delegate?.textFieldViewDidEndEditing(self)
    }
    
    func onEditingChanged(in textField: UITextField) {
        guard inputMask == Self.noMask else { return }
        delegate?.textFieldView(self, didChangeTextField: textField.text ?? "", didCompleteMask: true)
    }
    
    func textField(_ textField: UITextField, didFillMandatoryCharacters complete: Bool, didExtractValue value: String) {
        delegate?.textFieldView(self, didChangeTextField: value, didCompleteMask: complete)
    }
}
