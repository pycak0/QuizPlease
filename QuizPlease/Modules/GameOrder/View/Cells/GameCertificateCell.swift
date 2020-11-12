//
//  GameCertificateCell.swift
//  QuizPlease
//
//  Created by Владислав on 13.08.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import UIKit

protocol GameCertificateCellDelegate: class {
    func certificateCell(_ certificateCell: GameCertificateCell, didChangeCertificateCode newCode: String)
    
    func didPressOkButton(in certificateCell: GameCertificateCell)
}

class GameCertificateCell: UITableViewCell, GameOrderCellProtocol {
    static let identifier = "GameCertificateCell"
    
    weak var delegate: AnyObject? {
        get { _delegate }
        set { _delegate = newValue as? GameCertificateCellDelegate }
    }
    private weak var _delegate: GameCertificateCellDelegate?
    
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
        _delegate?.didPressOkButton(in: self)
        //_delegate?.certificateCell(self, didChangeCertificateCode: fieldView.textField.text ?? "")
    }
    
    func configureViews() {
        contentView.backgroundColor = UIColor.lightGreen.withAlphaComponent(0.2)
        okButton.layer.cornerRadius = 10
    }
    
    func configureTextField() {
        fieldView.textField.autocapitalizationType = .allCharacters
        fieldView.textField.returnKeyType = .done
        fieldView.delegate = self
    }
    
}


//MARK:- TitledTextFieldViewDelegate
extension GameCertificateCell: TitledTextFieldViewDelegate {
    func textFieldView(_ textFieldView: TitledTextFieldView, didChangeTextField text: String, didCompleteMask isComplete: Bool) {
        _delegate?.certificateCell(self, didChangeCertificateCode: text)
    }
}
