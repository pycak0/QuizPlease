//
//  GameSubmitButtonCell.swift
//  QuizPlease
//
//  Created by Владислав on 25.08.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import UIKit

protocol GameSubmitButtonCellDelegate: AnyObject {
    func submitButtonCell(_ cell: GameSubmitButtonCell, didPressSubmitButton button: UIButton)
    
    func titleForButton(in cell: GameSubmitButtonCell) -> String?
}

class GameSubmitButtonCell: UITableViewCell, GameOrderCellProtocol {
    static let identifier = "\(GameSubmitButtonCell.self)"
    
    @IBOutlet weak var submitButton: ScalingButton!
    @IBOutlet private weak var termsLabel: UILabel!
    
    weak var delegate: AnyObject? {
        get { _delegate }
        set { _delegate = newValue as? GameSubmitButtonCellDelegate }
    }
    private weak var _delegate: GameSubmitButtonCellDelegate? {
        didSet {
            updateTitle(with: _delegate?.titleForButton(in: self))
        }
    }
    
    @IBAction func submitButtonPressed(_ sender: UIButton) {
        _delegate?.submitButtonCell(self, didPressSubmitButton: sender)
    }
    
    func updateTitle(with newTitle: String?) {
        submitButton.setTitle(newTitle, for: .normal)
    }
}
