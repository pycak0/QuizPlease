//
//MARK:  GameOnlinePaymentCell.swift
//  QuizPlease
//
//  Created by Владислав on 25.08.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import UIKit

//MARK:- Delegate Protocol
protocol GameOnlinePaymentCellDelegate: class {
    ///Initial number of people to set in the cell
    func selectedNumberOfPeople(in cell: GameOnlinePaymentCell) -> Int
    
    func maxNumberOfPeopleToPay(in cell: GameOnlinePaymentCell) -> Int
    
    ///Requires the sum to pay for selected number of people. Delegate (Data source) must update its value with the new `number` value here.
    func sumToPay(in cell: GameOnlinePaymentCell, forNumberOfPeople number: Int) -> Int
}

class GameOnlinePaymentCell: UITableViewCell, GameOrderCellProtocol {
    static let identifier = "GameOnlinePaymentCell"
    
    @IBOutlet private weak var countPicker: CountPickerView!
    @IBOutlet private weak var dashView: UIView!
    @IBOutlet private weak var priceLabel: UILabel!
    
    var selectedNumberOfPeopleToPay: Int {
        return countPicker.selectedIndex + countPicker.startCount
    }
    
    weak var delegate: AnyObject? {
        get { _delegate }
        set { _delegate = newValue as? GameOnlinePaymentCellDelegate }
    }
    private weak var _delegate: GameOnlinePaymentCellDelegate? {
        didSet {
            guard let delegate = _delegate else { return }
            updateMaxNumberOfPeople(delegate.maxNumberOfPeopleToPay(in: self))
            //let number = delegate.selectedNumberOfPeople(in: self)
            //countPicker.setSelectedButton(at: number - countPicker.startCount)
        }
    }
    
    func updateMaxNumberOfPeople(_ number: Int) {
        countPicker.maxButtonsCount = number - countPicker.startCount + 1
    }
    
    //MARK:- Awake From Nib
    override func awakeFromNib() {
        super.awakeFromNib()
        configureCell()
    }
    
    //MARK:- Layout Subviews
    override func layoutSubviews() {
        super.layoutSubviews()
        configureViews()
    }
    
    private func configureCell() {
        countPicker.delegate = self
        countPicker.buttonsTitleFont = UIFont(name: "Gilroy-SemiBold", size: 16)
    }
    
    private func configureViews() {
        countPicker.buttonsCornerRadius = countPicker.frame.height / 2
        
        let start = CGPoint(x: dashView.bounds.minX + 3, y: dashView.frame.maxY - 8)
        let end = CGPoint(x: priceLabel.frame.minX - 3, y: dashView.frame.maxY - 8)
        UIView.drawDottedLine(in: dashView, start: start, end: end, dashLength: 4, gapLength: 2)
    }

}

//MARK:- CountPickViewDelegate
extension GameOnlinePaymentCell: CountPickerViewDelegate {
    func countPicker(_ picker: CountPickerView, didChangeSelectedNumber number: Int) {
        let newPrice = _delegate?.sumToPay(in: self, forNumberOfPeople: number) ?? 0
        //print("\(newPrice)")
        priceLabel.text = "\(newPrice)"
    }
}
