//
//  ExpandingHeaderTextField.swift
//  ExpandingTableViewHeader
//
//  Created by Владислав on 18.08.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import UIKit

extension ExpandingHeader: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        //
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        //
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        true
    }
}

extension ExpandingHeader {
    @objc
    func textFieldDidChange(_ textField: UITextField) {
        guard let query = textField.text else { return }
        delegate?.expandingHeader(self, didChange: query)
    }
}
