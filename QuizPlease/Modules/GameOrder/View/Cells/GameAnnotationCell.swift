//
//  GameAnnotationCell.swift
//  QuizPlease
//
//  Created by Владислав on 12.08.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import UIKit

protocol GameAnnotationCellDelegate: class {
    func signUpButtonPressed(in cell: GameAnnotationCell)
}

class GameAnnotationCell: UITableViewCell, TableCellProtocol {
    static let identifier = "GameAnnotationCell"
    
    weak var delegate: GameAnnotationCellDelegate?
    
    @IBOutlet weak var annotationLabel: UILabel!
    @IBOutlet weak var signUpButton: UIButton!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        configureViews()
    }
    
    @IBAction func didPressSignUpButton(_ sender: UIButton) {
        delegate?.signUpButtonPressed(in: self)
    }
    
    
    func configureViews() {
        signUpButton.layer.cornerRadius = signUpButton.frame.height / 2
    }
    
}