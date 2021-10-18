//
//  GameAnnotationCell.swift
//  QuizPlease
//
//  Created by Владислав on 12.08.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import UIKit

protocol GameAnnotationCellDelegate: AnyObject {
    func signUpButtonPressed(in cell: GameAnnotationCell)
    func gameAnnotation(for cell: GameAnnotationCell) -> String
}

class GameAnnotationCell: UITableViewCell, GameOrderCellProtocol {
    static let identifier = "GameAnnotationCell"
    
    @IBOutlet weak var annotationLabel: UILabel!
    @IBOutlet weak var signUpButton: ScalingButton!
    
    weak var delegate: AnyObject? {
        get { _delegate }
        set { _delegate = newValue as? GameAnnotationCellDelegate }
    }
    private weak var _delegate: GameAnnotationCellDelegate? {
        didSet {
            if let text = _delegate?.gameAnnotation(for: self) {
                annotationLabel.text = text
            }
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        configureViews()
    }
    
    @IBAction func didPressSignUpButton(_ sender: UIButton) {
        _delegate?.signUpButtonPressed(in: self)
    }
    
    
    func configureViews() {
        signUpButton.layer.cornerRadius = signUpButton.frame.height / 2
    }
    
}
