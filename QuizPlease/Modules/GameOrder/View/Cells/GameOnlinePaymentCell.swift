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
    let startCount = 2
    
    @IBOutlet private weak var teamCountStack: UIStackView!
    @IBOutlet private weak var dashView: UIView!
    @IBOutlet private weak var priceLabel: UILabel!
    
    weak var delegate: AnyObject? {
        get { _delegate }
        set { _delegate = newValue as? GameOnlinePaymentCellDelegate }
    }
    private weak var _delegate: GameOnlinePaymentCellDelegate? {
        didSet {
            guard let delegate = _delegate else { return }
            updateSelectedButton(withNumberOfPeople: delegate.selectedNumberOfPeople(in: self))
            maxNumber = delegate.maxNumberOfPeopleToPay(in: self)
        }
    }
    
    //MARK:- Max Number
    var maxNumber: Int! {
        didSet {
            let index = maxNumber + 1 - startCount
            for i in 0..<teamCountStack.arrangedSubviews.count {
                teamCountStack.arrangedSubviews[i].isHidden = i >= index
//                teamCountStack.arrangedSubviews[i].alpha = 0.4
//                teamCountStack.arrangedSubviews[i].isUserInteractionEnabled = false
            }
            updateSelectedButton(withNumberOfPeople: maxNumber)
        }
    }
    
    //MARK:- Count Button Pressed
    @IBAction func countButtonPressed(_ sender: UIButton) {
        guard let index = teamCountStack.arrangedSubviews.firstIndex(of: sender),
            index + startCount != _delegate?.selectedNumberOfPeople(in: self) else {
            return
        }
        
        let selectedNumberOfPeople = index + startCount
        //_delegate?.gamePayCell(self, didChangeNumberOfPeopleToPay: selectedNumberOfPeople)
        updateSelectedButton(withNumberOfPeople: selectedNumberOfPeople)
    }
    
    //MARK:- Update Count Buttons
    func updateSelectedButton(withNumberOfPeople number: Int) {
        deselectAllButtons()
        guard number >= startCount && number < teamCountStack.arrangedSubviews.count + startCount else {
            return
        }
        //let selectedIndex = (number <= maxNumber ? number : _delegate?.selectedNumberOfPeople(in: self) ?? startCount) - startCount
        let selectedButton = teamCountStack.arrangedSubviews[number - startCount] as! UIButton

        select(selectedButton, number: number)
        
        let newPrice = _delegate?.sumToPay(in: self, forNumberOfPeople: number) ?? 0
        priceLabel.text = "\(newPrice)"
    }
    
    //MARK:- Select
    private func select(_ button: UIButton, number: Int) {
        let scale: CGFloat = 1.1
        UIView.animate(withDuration: 0.2) {
            button.setTitle("\(number)", for: .normal)
            button.setImage(nil, for: .normal)
            button.backgroundColor = .systemBlue
            button.transform = CGAffineTransform(scaleX: scale, y: scale)
        }
        
    }
    
    //MARK:- Deselect
    private func deselect(_ button: UIButton?) {
        var backgroundColor = UIColor.white
        if #available(iOS 13.0, *) {
            backgroundColor = .systemBackground
        }
        UIView.animate(withDuration: 0.2) {
            button?.setImage(UIImage(named: "human"), for: .normal)
            button?.setTitle("", for: .normal)
            button?.backgroundColor = backgroundColor
            button?.transform = .identity
        }
        
    }
    
    private func deselectAllButtons() {
        teamCountStack.arrangedSubviews.forEach {
            let button = $0 as? UIButton
            deselect(button)
        }
    }
    
    //MARK:- Layout Subviews
    override func layoutSubviews() {
        super.layoutSubviews()
        configureCell()
    }
    
    private func configureCell() {
        teamCountStack.arrangedSubviews.forEach {
            $0.layer.cornerRadius = $0.bounds.height / 2
        }
        
        let start = CGPoint(x: dashView.bounds.minX + 3, y: dashView.frame.maxY - 8)
        let end = CGPoint(x: priceLabel.frame.minX - 3, y: dashView.frame.maxY - 8)
        UIView.drawDottedLine(in: dashView, start: start, end: end, dashLength: 4, gapLength: 2)
    }

}
