//
//  GameCertificateCell.swift
//  QuizPlease
//
//  Created by Владислав on 13.08.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import UIKit

protocol CertificateCellDelegate: class {
    func okButtonPressed(in cell: GameCertificateCell)
}

class GameCertificateCell: UITableViewCell, TableCellProtocol {
    static let identifier = "GameCertificateCell"
    
    weak var delegate: CertificateCellDelegate?
    
    @IBOutlet weak var okButton: UIButton!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.backgroundColor = UIColor.lightGreen.withAlphaComponent(0.2)
        okButton.layer.cornerRadius = 10
    }
    
    @IBOutlet weak var fieldView: TitledTextFieldView!
    
    @IBAction func okButtonPressed(_ sender: UIButton) {
        delegate?.okButtonPressed(in: self)
    }
    
}
