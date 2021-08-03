//
//  GameCertificateCell.swift
//  QuizPlease
//
//  Created by Владислав on 13.08.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import UIKit

///If cell delegate is not provided, it uses the default `title` and `accessoryText` values
protocol GameCertificateCellDelegate: AnyObject {
    func titleForCell(_ certificateCell: GameCertificateCell) -> String
        
    ///If the provided string is an empty string, the accessoryTitleLabel will be hidden
    func accessoryText(for certificateCell: GameCertificateCell) -> String
        
    func certificateCell(_ certificateCell: GameCertificateCell, didChangeCertificateCode newCode: String)
    
    func certificateCellDidEndEditing(_ certificateCell: GameCertificateCell)
    
    func didPressOkButton(in certificateCell: GameCertificateCell)
}

class GameCertificateCell: UITableViewCell, GameOrderCellProtocol {
    static let identifier = "GameCertificateCell"
    
    weak var delegate: AnyObject? {
        get { _delegate }
        set { _delegate = newValue as? GameCertificateCellDelegate }
    }
    private weak var _delegate: GameCertificateCellDelegate? {
        didSet {
            updateUI()
        }
    }
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var accessoryLabel: UILabel!
    @IBOutlet private weak var okButton: UIButton!
    @IBOutlet weak var fieldView: TitledTextFieldView! {
        didSet {
            fieldView.backgroundColor = .systemBackgroundAdapted
            fieldView.textField.autocapitalizationType = .none
            fieldView.textField.returnKeyType = .done
            fieldView.delegate = self
        }
    }
    
    var associatedItemKind: GameOrderVC.GameInfoItemKind?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureViews()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        delegate = nil
        fieldView.textField.text = nil
    }
        
    @IBAction private func okButtonPressed(_ sender: UIButton) {
        _delegate?.didPressOkButton(in: self)
        //_delegate?.certificateCell(self, didChangeCertificateCode: fieldView.textField.text ?? "")
    }
    
    private func configureViews() {
        contentView.backgroundColor = UIColor.lightGreen.withAlphaComponent(0.2)
        okButton.layer.cornerRadius = 10
    }
    
    private func updateUI() {
        guard let delegate = _delegate else { return }
        let title = delegate.titleForCell(self)
        let accessoryTitle = delegate.accessoryText(for: self)
        titleLabel.text = title
        accessoryLabel.text = accessoryTitle
        accessoryLabel.isHidden = accessoryTitle.isEmpty
        if accessoryLabel.isHidden {
            setNeedsLayout()
            layoutIfNeeded()
        }
    }
}


//MARK:- TitledTextFieldViewDelegate
extension GameCertificateCell: TitledTextFieldViewDelegate {
    func textFieldViewDidEndEditing(_ textFieldView: TitledTextFieldView) {
        _delegate?.certificateCellDidEndEditing(self)
    }
    
    func textFieldView(_ textFieldView: TitledTextFieldView, didChangeTextField text: String) {
        _delegate?.certificateCell(self, didChangeCertificateCode: text)
    }
}
