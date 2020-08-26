//
//  GameSubmitButtonCell.swift
//  QuizPlease
//
//  Created by Владислав on 25.08.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import UIKit

protocol GameSubmitButtonCellDelegate: class {
    func submitButtonCell(_ cell: GameSubmitButtonCell, didPressSubmitButton button: UIButton)
}

class GameSubmitButtonCell: UITableViewCell, GameOrderCellProtocol {
    static let identifier = "GameSubmitButtonCell"
    
    @IBOutlet weak var submitButton: ScalingButton!
    @IBOutlet private weak var termsLabel: UILabel!
    
    weak var delegate: AnyObject? {
        get { _delegate }
        set { _delegate = newValue as? GameSubmitButtonCellDelegate }
    }
    private weak var _delegate: GameSubmitButtonCellDelegate?
    
    @IBAction func submitButtonPressed(_ sender: UIButton) {
        _delegate?.submitButtonCell(self, didPressSubmitButton: sender)
    }
    
}
