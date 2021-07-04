//
//  GamePaymentTypeCell.swift
//  QuizPlease
//
//  Created by Владислав on 25.08.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import UIKit

protocol GamePaymentTypeCellDelegate: AnyObject {
    func availablePaymentTypes(in cell: GamePaymentTypeCell) -> [PaymentType]
    
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
            setPaymentTypes()
            updateViews(isOnlinePayment: delegate.isOnlinePaymentInitially(in: self))
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
    ///Must be called only in response on user actions
    func updatePaymentType(isOnlinePayment: Bool) {
        _delegate?.paymentTypeCell(self, didChangePaymentType: isOnlinePayment)
        updateViews(isOnlinePayment: isOnlinePayment)
    }
    
    private func updateViews(isOnlinePayment: Bool) {
        cashCheckBox.image = !isOnlinePayment ? UIImage(named: "rectDot") : nil
        onlineCheckBox.image = isOnlinePayment ? UIImage(named: "rectDot") : nil
    }
    
    func setPaymentTypes() {
        guard let types = _delegate?.availablePaymentTypes(in: self) else { return }
        guard types.count <= 2, types.count >= 1 else {
            fatalError("Invalid count of payment types. Only online and cash (max 2, min 1) type(s) are supported now.")
        }
        guard types.count == 1 else { return }
        let singleType = types.first!
        cashTypeView.isHidden = singleType == .online
        onlineTypeView.isHidden = singleType == .cash
    }
}
