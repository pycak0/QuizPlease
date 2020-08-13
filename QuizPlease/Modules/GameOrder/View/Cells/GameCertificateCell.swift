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
    
    @IBOutlet weak var fieldView: TitledTextFieldView!
    
    @IBAction func okButtonPressed(_ sender: UIButton) {
        delegate?.okButtonPressed(in: self)
    }
    
}
