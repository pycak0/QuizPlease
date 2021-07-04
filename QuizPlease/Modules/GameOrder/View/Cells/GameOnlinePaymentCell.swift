//
//MARK:  GameOnlinePaymentCell.swift
//  QuizPlease
//
//  Created by Владислав on 25.08.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import UIKit

//MARK:- Delegate Protocol
protocol GameOnlinePaymentCellDelegate: AnyObject {
    ///Initial number of people to set in the cell
    func selectedNumberOfPeople(in cell: GameOnlinePaymentCell) -> Int
    
    func maxNumberOfPeopleToPay(in cell: GameOnlinePaymentCell) -> Int
    
    ///Requires the sum to pay for selected number of people. Delegate (Data source) must update its value with the new `number` value here.
    func sumToPay(in cell: GameOnlinePaymentCell, forUpdatedNumberOfPeople number: Int) -> Double
    
    ///If `nil`, the default color is `UIColor.label`
    func priceTextColor(in cell: GameOnlinePaymentCell) -> UIColor?
    
    func shouldDisplayCountPicker(in cell: GameOnlinePaymentCell) -> Bool
}

class GameOnlinePaymentCell: UITableViewCell, GameOrderCellProtocol {
    static let identifier = "\(GameOnlinePaymentCell.self)"
    
    @IBOutlet private weak var countPicker: CountPickerView!
    @IBOutlet private weak var paymentCommentLabel: UILabel!
    @IBOutlet private weak var dashView: UIView!
    @IBOutlet private weak var priceLabel: UILabel!
    private weak var dashedLine: CAShapeLayer?
    
    //MARK:- Public
    var selectedNumberOfPeopleToPay: Int {
        return countPicker.selectedIndex + countPicker.startCount
    }
    
    var maxNumberOfPeople: Int {
        return countPicker.maxButtonsCount + countPicker.startCount - 1
    }
    
    func updateMaxNumberOfPeople(_ number: Int) {
        countPicker.maxButtonsCount = number - countPicker.startCount + 1
        updatePrice(withNumberOfPeople: number)
    }
    
    func setPrice(_ price: Double) {
        let priceColor = _delegate?.priceTextColor(in: self) ?? .labelAdapted
        priceLabel.text = NumberFormatter.decimalFormatter.string(from: price as NSNumber) ?? "N/A"
        priceLabel.textColor = priceColor
    }
        
    weak var delegate: AnyObject? {
        get { _delegate }
        set { _delegate = newValue as? GameOnlinePaymentCellDelegate }
    }
    private weak var _delegate: GameOnlinePaymentCellDelegate? {
        didSet {
            guard let delegate = _delegate else { return }
            updateMaxNumberOfPeople(delegate.maxNumberOfPeopleToPay(in: self))
        }
    }
    
    //MARK:- Awake From Nib
    override func awakeFromNib() {
        super.awakeFromNib()
        configureCell()
        updatePicker()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        updatePicker()
    }
    
    //MARK:- Layout Subviews
    override func layoutSubviews() {
        super.layoutSubviews()
        configureViews()
        reloadPrice()
    }
    
    private func configureCell() {
        countPicker.delegate = self
        countPicker.buttonsTitleFont = .gilroy(.semibold, size: 16)
        countPicker.startCount = 1
    }
    
    private func configureViews() {
        countPicker.buttonsCornerRadius = countPicker.frame.height / 2
        
        dashedLine?.removeFromSuperlayer()
        let start = CGPoint(x: dashView.bounds.minX + 3, y: dashView.frame.maxY - 8)
        let end = CGPoint(x: priceLabel.frame.minX - 3, y: dashView.frame.maxY - 8)
        dashedLine = UIView.drawDottedLine(in: dashView, start: start, end: end, dashLength: 4, gapLength: 2)
    }
    
    //MARK:- Update Picker
    private func updatePicker() {
        guard let delegate = _delegate else { return }
        guard delegate.shouldDisplayCountPicker(in: self) else {
            countPicker.isHidden = true
            paymentCommentLabel.isHidden = true
            return
        }
        let maxNumberOfPeople = delegate.maxNumberOfPeopleToPay(in: self)
        if maxNumberOfPeople != self.maxNumberOfPeople {
            updateMaxNumberOfPeople(maxNumberOfPeople)
        } else {
            let numberOfPeople = delegate.selectedNumberOfPeople(in: self)
            let selectedIndex = numberOfPeople - countPicker.startCount
            countPicker.setSelectedButton(at: selectedIndex, animated: true)
            updatePrice(withNumberOfPeople: numberOfPeople)
        }
    }
    
    private func reloadPrice() {
        guard let delegate = _delegate else { return }
        let numberOfPeople = delegate.selectedNumberOfPeople(in: self)
        updatePrice(withNumberOfPeople: numberOfPeople)
    }
    
    private func updatePrice(withNumberOfPeople number: Int) {
        let newPrice = _delegate?.sumToPay(in: self, forUpdatedNumberOfPeople: number) ?? 0
        setPrice(newPrice)
    }
}

//MARK:- CountPickViewDelegate
extension GameOnlinePaymentCell: CountPickerViewDelegate {
    func countPicker(_ picker: CountPickerView, didChangeSelectedNumber number: Int) {
        updatePrice(withNumberOfPeople: number)
    }
}
