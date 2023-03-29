//
//  GameAnnotationCell.swift
//  QuizPlease
//
//  Created by Владислав on 12.08.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import UIKit

/// GameAnnotationCell delegate protocol
protocol GameAnnotationCellDelegate: AnyObject {

    /// Did press sign up button
    func signUpButtonPressed(in cell: GameAnnotationCell)

    /// Asks `delegate` to provide game annotation text
    func gameAnnotation(for cell: GameAnnotationCell) -> String

    /// Asks `delegate` to provide game annotation register button options
    func registerButtonOpptions(for cell: GameAnnotationCell) -> GameAnnotationRegisterButtonOptions?
}

/// Cell containing an annotation of the game and a register button
final class GameAnnotationCell: UITableViewCell, GameOrderCellProtocol {

    static let identifier = "\(GameAnnotationCell.self)"

    // MARK: - UI Elements

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
            if let options = _delegate?.registerButtonOpptions(for: self) {
                signUpButton.isEnabled = options.isEnabled
                signUpButton.setTitle(options.title, for: .normal)
                signUpButton.backgroundColor = options.color
            }
        }
    }

    // MARK: - Lifecycle

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
