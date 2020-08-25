//
//  GamePaymentTypeCell.swift
//  QuizPlease
//
//  Created by Владислав on 25.08.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import UIKit

protocol GamePaymentTypeCellDelegate: class {
    func isOnlinePaymentInitially(in cell: GamePaymentTypeCell) -> Bool
    
    func paymentTypeCell(_ cell: GamePaymentTypeCell, didChangePaymentType isOnlinePayment: Bool)
}

class GamePaymentTypeCell: UITableViewCell, GameOrderCellProtocol {
    static let identifier = "GamePaymentTypeCell"
    
    @IBOutlet private weak var cashCheckBox: UIImageView!
    @IBOutlet private weak var onlineCheckBox: UIImageView!
    @IBOutlet private weak var cashTypeView: UIStackView!
    @IBOutlet private weak var onlineTypeView: UIStackView!
    
    weak var delegate: AnyObject? {
        get { _delegate }
        set { _delegate = newValue as? GamePaymentTypeCellDelegate }
    }
    private weak var _delegate: GamePaymentTypeCellDelegate? {
        didSet {
            guard let delegate = _delegate else { return }
            updatePaymentType(isOnlinePayment: delegate.isOnlinePaymentInitially(in: self))
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureCell()
    }
    
    private func configureCell() {
        cashTypeView.addTapGestureRecognizer {
            self.updatePaymentType(isOnlinePayment: false)
        }
        onlineTypeView.addTapGestureRecognizer {
            self.updatePaymentType(isOnlinePayment: true)
        }
    }
    
    //MARK:- Update Payment Type
    private func updatePaymentType(isOnlinePayment: Bool) {
        _delegate?.paymentTypeCell(self, didChangePaymentType: isOnlinePayment)
        
        cashCheckBox.image = !isOnlinePayment ? UIImage(named: "rectDot") : nil
        onlineCheckBox.image = isOnlinePayment ? UIImage(named: "rectDot") : nil
    }
}
