//
//  GameSubmitButtonCell.swift
//  QuizPlease
//
//  Created by Владислав on 25.08.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import UIKit

protocol GameSubmitButtonCellDelegate: AnyObject {
    func didPressTermsOfUse(in cell: GameSubmitButtonCell)

    func submitButtonCell(_ cell: GameSubmitButtonCell, didPressSubmitButton button: UIButton)

    func titleForButton(in cell: GameSubmitButtonCell) -> String?
}

class GameSubmitButtonCell: UITableViewCell, GameOrderCellProtocol {
    static let identifier = "\(GameSubmitButtonCell.self)"

    @IBOutlet weak var submitButton: ScalingButton!
    @IBOutlet private weak var termsButton: UIButton! {
        didSet {
            setupTermsButton()
        }
    }

    weak var delegate: AnyObject? {
        get { _delegate }
        set { _delegate = newValue as? GameSubmitButtonCellDelegate }
    }
    private weak var _delegate: GameSubmitButtonCellDelegate? {
        didSet {
            setButtonTitle(_delegate?.titleForButton(in: self))
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        setButtonTitle(_delegate?.titleForButton(in: self))
    }

    func setButtonTitle(_ newTitle: String?) {
        submitButton.setTitle(newTitle, for: .normal)
    }

    @IBAction private func submitButtonPressed(_ sender: UIButton) {
        _delegate?.submitButtonCell(self, didPressSubmitButton: sender)
    }

    @objc private func termsButtonPressed() {
        _delegate?.didPressTermsOfUse(in: self)
    }

    private func setupTermsButton() {
        let attrString = NSMutableAttributedString(string: "Записываясь на игру, вы соглашаетесь c условиями ")
        attrString.append(NSAttributedString(
            string: "пользовательского соглашения",
            attributes: [.foregroundColor: UIColor.themePink]
        ))
        let pStyle = NSMutableParagraphStyle()
        pStyle.alignment = .center
        let range = (attrString.string as NSString).range(of: attrString.string)
        attrString.addAttributes(
            [.paragraphStyle: pStyle,
             .font: UIFont.gilroy(.semibold, size: 12)],
            range: range
        )
        termsButton.setAttributedTitle(attrString, for: .normal)
        termsButton.addTarget(self, action: #selector(termsButtonPressed), for: .touchUpInside)
    }
}
