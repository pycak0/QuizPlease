//
//  ExpandingHeaderTextField.swift
//  ExpandingTableViewHeader
//
//  Created by Владислав on 18.08.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import UIKit

extension ExpandingHeader: UITextFieldDelegate {
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        //
    }
    
    public func textFieldDidEndEditing(_ textField: UITextField) {
        delegate?.expandingHeader(self, didEndSearchingWith: textField.text ?? "")
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        delegate?.expandingHeader(self, didPressReturnButtonWith: textField.text ?? "")
        textField.resignFirstResponder()
        return true
    }
}

extension ExpandingHeader {
    @objc
    func textFieldDidChange(_ textField: UITextField) {
        guard let query = textField.text else { return }
        delegate?.expandingHeader(self, didChange: query)
    }
}
