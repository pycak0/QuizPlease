//
//  GameCertificateCell.swift
//  QuizPlease
//
//  Created by Владислав on 13.08.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import UIKit

protocol GameCertificateCellDelegate: class {
    func certificateCell(_ certificateCell: GameCertificateCell, didAskConfirmationFor code: String)
}

class GameCertificateCell: UITableViewCell, TableCellProtocol {
    static let identifier = "GameCertificateCell"
    
    weak var delegate: GameCertificateCellDelegate?
    
    @IBOutlet weak var okButton: UIButton!
    @IBOutlet weak var fieldView: TitledTextFieldView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureTextField()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        configureViews()
    }

    @IBAction func okButtonPressed(_ sender: UIButton) {
        delegate?.certificateCell(self, didAskConfirmationFor: fieldView.textField.text ?? "")
    }
    
    func configureViews() {
        contentView.backgroundColor = UIColor.lightGreen.withAlphaComponent(0.2)
        okButton.layer.cornerRadius = 10
    }
    
    func configureTextField() {
        fieldView.textField.autocapitalizationType = .allCharacters
        fieldView.textField.returnKeyType = .done
        fieldView.textField.delegate = self
    }
    
}


extension GameCertificateCell: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        true
    }
}
